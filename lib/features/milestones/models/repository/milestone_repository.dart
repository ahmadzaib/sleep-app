import 'package:avatar_flow/core/services/supabase_client.dart';

class MilestoneRepository {
  /// MAIN ENTRY POINT
  Future<void> handleAction({
    required String userId,
    required String actionType,
  }) async {
    // 1. Get active milestone
    final milestone = await _getActiveMilestone(userId);

    if (milestone == null) return;

    // 2. Get task for this milestone
    final task = await _getTask(milestone['id']);

    if (task == null) return;

    // 3. Check if action matches task
    if (task['task_type'] != actionType) return;

    // 4. Update task progress
    await _incrementTask(userId, task['id']);

    // 5. Check completion
    final isCompleted = await _checkMilestoneCompletion(
      userId,
      milestone['id'],
      task['target_count'],
    );

    if (isCompleted) {
      await _completeMilestone(userId, milestone['id']);
      await _unlockNextMilestone(userId, milestone['order_index']);
    }
  }

  // =========================
  // PRIVATE FUNCTIONS
  // =========================

  Future<Map?> _getActiveMilestone(String userId) async {
    final res = await supabase
        .from('user_milestone_progress')
        .select('*, milestones(*)')
        .eq('user_id', userId)
        .eq('is_unlocked', true)
        .eq('is_completed', false)
        .maybeSingle();

    return res;
  }

  Future<Map?> _getTask(int milestoneId) async {
    final res = await supabase
        .from('tasks')
        .select()
        .eq('milestone_id', milestoneId)
        .maybeSingle();

    return res;
  }

  Future<void> _incrementTask(String userId, int taskId) async {
    final existing = await supabase
        .from('user_task_progress')
        .select()
        .eq('user_id', userId)
        .eq('task_id', taskId)
        .maybeSingle();

    if (existing == null) {
      await supabase.from('user_task_progress').insert({
        'user_id': userId,
        'task_id': taskId,
        'current_count': 1,
      });
    } else {
      await supabase
          .from('user_task_progress')
          .update({'current_count': existing['current_count'] + 1})
          .eq('id', existing['id']);
    }
  }

  Future<bool> _checkMilestoneCompletion(
    String userId,
    int milestoneId,
    int targetCount,
  ) async {
    final res = await supabase
        .from('user_task_progress')
        .select()
        .eq('user_id', userId)
        .eq('task_id', milestoneId)
        .maybeSingle();

    if (res == null) return false;

    return res['current_count'] >= targetCount;
  }

  Future<void> _completeMilestone(String userId, int milestoneId) async {
    await supabase
        .from('user_milestone_progress')
        .update({'is_completed': true, 'is_unlocked': false})
        .eq('user_id', userId)
        .eq('milestone_id', milestoneId);
  }

  Future<void> _unlockNextMilestone(String userId, int currentOrder) async {
    final next = await supabase
        .from('user_milestone_progress')
        .select()
        .eq('user_id', userId)
        .eq('is_completed', false)
        .order('milestones(order_index)')
        .limit(1)
        .maybeSingle();

    if (next == null) return;

    await supabase
        .from('user_milestone_progress')
        .update({'is_unlocked': true})
        .eq('id', next['id']);
  }
}
