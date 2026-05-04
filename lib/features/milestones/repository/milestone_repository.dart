import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/core/services/supabase_client.dart';
import 'package:avatar_flow/features/milestones/models/milestone_action_type.dart';

class MilestoneRepository {
  /// MAIN ENTRY POINT
  Future<void> handleAction({
    required String userId,
    required MilestoneActionType action,
  }) async {
    final actionType = action.value;
    DebugPoint.log('handleAction → userId: $userId, actionType: $actionType');

    // 1. Get active milestone
    final milestone = await _getActiveMilestone(userId);

    if (milestone == null) {
      DebugPoint.log('No active milestone found for user $userId');
      return;
    }

    final milestoneId = milestone['milestone_id'] as int;
    final orderIndex = milestone['milestones']?['order_index'] as int? ?? 0;
    DebugPoint.log('Active milestone → id: $milestoneId, order: $orderIndex');

    // 2. Get task for this milestone
    final task = await _getTask(milestoneId);

    if (task == null) {
      DebugPoint.log('No task found for milestone $milestoneId');
      return;
    }

    DebugPoint.log(
      'Task → id: ${task['id']}, type: ${task['task_type']}, target: ${task['target_count']}',
    );

    // 3. Check if action matches task
    if (task['task_type'] != actionType) {
      DebugPoint.log(
        'Action mismatch — expected: ${task['task_type']}, got: $actionType',
      );
      return;
    }

    // 4. Update task progress
    await _incrementTask(userId, task['id'] as int);

    // 5. Check completion
    final isCompleted = await _checkMilestoneCompletion(
      userId,
      task['id'] as int,
      task['target_count'] as int,
    );

    DebugPoint.log('Milestone completion check → isCompleted: $isCompleted');

    if (isCompleted) {
      await _completeMilestone(userId, milestoneId);
      await _unlockNextMilestone(userId, orderIndex);
    }
  }

  // =========================
  // PRIVATE FUNCTIONS
  // =========================

  Future<Map?> _getActiveMilestone(String userId) async {
    DebugPoint.log('_getActiveMilestone → userId: $userId');

    final res = await supabase
        .from('user_milestone_progress')
        .select('*, milestones(*)')
        .eq('user_id', userId)
        .eq('is_unlocked', true)
        .eq('is_completed', false)
        .maybeSingle();

    DebugPoint.log(
      '_getActiveMilestone result → ${res != null ? 'found' : 'null'}',
    );
    return res;
  }

  Future<Map?> _getTask(int milestoneId) async {
    DebugPoint.log('_getTask → milestoneId: $milestoneId');

    final res = await supabase
        .from('tasks')
        .select()
        .eq('milestone_id', milestoneId)
        .maybeSingle();

    DebugPoint.log(
      '_getTask result → ${res != null ? res['task_type'] : 'null'}',
    );
    return res;
  }

  Future<void> _incrementTask(String userId, int taskId) async {
    DebugPoint.log('_incrementTask → userId: $userId, taskId: $taskId');

    final existing = await supabase
        .from('user_task_progress')
        .select()
        .eq('user_id', userId)
        .eq('task_id', taskId)
        .maybeSingle();

    if (existing == null) {
      DebugPoint.log('No existing progress — inserting with count 1');
      await supabase.from('user_task_progress').insert({
        'user_id': userId,
        'task_id': taskId,
        'current_count': 1,
      });
    } else {
      final newCount = (existing['current_count'] as int) + 1;
      DebugPoint.log('Existing progress found — updating count to $newCount');
      await supabase
          .from('user_task_progress')
          .update({'current_count': newCount})
          .eq('id', existing['id']);
    }
  }

  /// BUG FIX: was querying task_id = milestoneId — now correctly uses taskId
  Future<bool> _checkMilestoneCompletion(
    String userId,
    int taskId,
    int targetCount,
  ) async {
    DebugPoint.log(
      '_checkMilestoneCompletion → userId: $userId, taskId: $taskId, target: $targetCount',
    );

    final res = await supabase
        .from('user_task_progress')
        .select()
        .eq('user_id', userId)
        .eq('task_id', taskId)
        .maybeSingle();

    if (res == null) {
      DebugPoint.log('No task progress row found');
      return false;
    }

    final current = res['current_count'] as int? ?? 0;
    DebugPoint.log('current_count: $current / $targetCount');
    return current >= targetCount;
  }

  Future<void> _completeMilestone(String userId, int milestoneId) async {
    DebugPoint.log('_completeMilestone → milestoneId: $milestoneId');

    await supabase
        .from('user_milestone_progress')
        .update({'is_completed': true, 'is_unlocked': false})
        .eq('user_id', userId)
        .eq('milestone_id', milestoneId);

    DebugPoint.log('Milestone $milestoneId marked as completed');
  }

  /// BUG FIX: .order('milestones(order_index)') doesn't work in PostgREST.
  /// Now fetches the next milestone by order_index directly from milestones table.
  Future<void> _unlockNextMilestone(String userId, int currentOrder) async {
    DebugPoint.log(
      '_unlockNextMilestone → userId: $userId, currentOrder: $currentOrder',
    );

    // Find the next milestone by order_index
    final nextMilestone = await supabase
        .from('milestones')
        .select('id, order_index')
        .gt('order_index', currentOrder)
        .order('order_index')
        .limit(1)
        .maybeSingle();

    if (nextMilestone == null) {
      DebugPoint.log('No next milestone — user has completed all milestones');
      return;
    }

    final nextMilestoneId = nextMilestone['id'] as int;
    DebugPoint.log(
      'Next milestone → id: $nextMilestoneId, order: ${nextMilestone['order_index']}',
    );

    await supabase
        .from('user_milestone_progress')
        .update({'is_unlocked': true})
        .eq('user_id', userId)
        .eq('milestone_id', nextMilestoneId);

    DebugPoint.log('Milestone $nextMilestoneId unlocked for user $userId');
  }
}
