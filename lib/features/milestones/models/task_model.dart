class TaskModel {
  final int id;
  final int milestoneId;
  final String taskType;
  final int targetCount;

  TaskModel({
    required this.id,
    required this.milestoneId,
    required this.taskType,
    required this.targetCount,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      milestoneId: map['milestone_id'],
      taskType: map['task_type'],
      targetCount: map['target_count'],
    );
  }
}
