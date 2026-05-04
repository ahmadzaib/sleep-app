import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/core/services/supabase_client.dart';
import 'package:avatar_flow/features/milestones/models/milestone_with_task.dart';
import 'package:avatar_flow/features/milestones/models/milestones_model.dart';
import 'package:avatar_flow/features/milestones/models/task_model.dart';
import 'package:flutter/material.dart';

class MilestonesProvider extends ChangeNotifier {
  List<MilestoneWithTask> _milestones = [];
  List<MilestoneWithTask> get milestones => _milestones;

  /// The currently active milestone — unlocked and not yet completed
  MilestoneWithTask? get currentMilestone =>
      _milestones.where((m) => m.isUnlocked && !m.isCompleted).firstOrNull;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String? get _userId => supabase.auth.currentUser?.id;

  Future<void> fetchMilestones() async {
    final userId = _userId;
    if (userId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Fetch all milestones (source of truth, always exists)
      final milestoneRows = await supabase
          .from('milestones')
          .select()
          .order('order_index');

      DebugPoint.log('All milestones: ${(milestoneRows as List).length}');

      if (milestoneRows.isEmpty) {
        _milestones = [];
        return;
      }

      // 2. Fetch user progress rows — seed if missing
      var progressRows = await supabase
          .from('user_milestone_progress')
          .select()
          .eq('user_id', userId);

      DebugPoint.log(
        'User progress rows before seed: ${(progressRows as List).length}',
      );

      if (progressRows.isEmpty) {
        await _initUserMilestones(userId, milestoneRows);
        progressRows = await supabase
            .from('user_milestone_progress')
            .select()
            .eq('user_id', userId);
        DebugPoint.log(
          'User progress rows after seed: ${(progressRows as List).length}',
        );
      }

      // Build progress lookup: milestone_id → progress row
      final progressByMilestoneId = <int, Map>{};
      for (final row in progressRows as List) {
        progressByMilestoneId[row['milestone_id'] as int] = row;
      }

      // 3. Fetch all tasks
      final taskRows = await supabase.from('tasks').select();
      final tasksByMilestone = <int, TaskModel>{};
      for (final row in taskRows as List) {
        final task = TaskModel.fromMap(row);
        tasksByMilestone[task.milestoneId] = task;
      }

      // 4. Fetch user task progress
      final taskProgressRows = await supabase
          .from('user_task_progress')
          .select()
          .eq('user_id', userId);

      final progressByTaskId = <int, int>{};
      for (final row in taskProgressRows as List) {
        progressByTaskId[row['task_id'] as int] =
            row['current_count'] as int? ?? 0;
      }

      // 5. Combine — milestones already sorted by order_index from DB
      _milestones = (milestoneRows as List).map((mRow) {
        final milestoneId = mRow['id'] as int;
        final progressRow = progressByMilestoneId[milestoneId];

        final milestone = MilestoneModel.fromMap({
          ...mRow,
          'is_unlocked': progressRow?['is_unlocked'] ?? false,
          'is_completed': progressRow?['is_completed'] ?? false,
        });

        final task = tasksByMilestone[milestoneId];
        final currentCount = task != null
            ? (progressByTaskId[task.id] ?? 0)
            : 0;

        return MilestoneWithTask(
          milestone: milestone,
          task: task,
          currentCount: currentCount,
        );
      }).toList();

      DebugPoint.log('Built ${_milestones.length} MilestoneWithTask items');
    } catch (e, st) {
      _error = e.toString();
      DebugPoint.error('Failed to fetch milestones: $e\n$st');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Seeds user_milestone_progress for all milestones.
  /// First milestone (lowest order_index) is unlocked, rest are locked.
  Future<void> _initUserMilestones(String userId, List milestoneRows) async {
    try {
      final sorted = List.of(milestoneRows)
        ..sort(
          (a, b) =>
              (a['order_index'] as int).compareTo(b['order_index'] as int),
        );

      final firstId = sorted.first['id'] as int;

      final rows = sorted.map((m) {
        return {
          'user_id': userId,
          'milestone_id': m['id'],
          'is_unlocked': m['id'] == firstId,
          'is_completed': false,
        };
      }).toList();

      // insert with ignoreDuplicates — safe to call multiple times
      await supabase
          .from('user_milestone_progress')
          .insert(rows, defaultToNull: false);

      DebugPoint.log('Seeded ${rows.length} milestone rows for $userId');
    } catch (e) {
      // Rows may already exist (e.g. unique constraint violation) — not fatal
      DebugPoint.error('Seed error (may be duplicate, non-fatal): $e');
    }
  }
}
