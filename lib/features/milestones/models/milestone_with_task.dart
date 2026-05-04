import 'package:avatar_flow/features/milestones/models/milestones_model.dart';
import 'package:avatar_flow/features/milestones/models/task_model.dart';

/// Combines a milestone with its task and the user's current progress on that task.
class MilestoneWithTask {
  final MilestoneModel milestone;
  final TaskModel? task;
  final int currentCount;

  MilestoneWithTask({
    required this.milestone,
    required this.task,
    required this.currentCount,
  });

  int get targetCount => task?.targetCount ?? 1;

  double get progress =>
      targetCount > 0 ? (currentCount / targetCount).clamp(0.0, 1.0) : 0.0;

  bool get isCompleted => milestone.isCompleted;
  bool get isUnlocked => milestone.isUnlocked;
  bool get isLocked => !milestone.isUnlocked && !milestone.isCompleted;
}
