class MilestoneModel {
  final int id;
  final String title;
  final bool isUnlocked;
  final bool isCompleted;
  final int orderIndex;

  MilestoneModel({
    required this.id,
    required this.title,
    required this.isUnlocked,
    required this.isCompleted,
    required this.orderIndex,
  });

  factory MilestoneModel.fromMap(Map<String, dynamic> map) {
    return MilestoneModel(
      id: map['id'],
      title: map['title'],
      isUnlocked: map['is_unlocked'] ?? false,
      isCompleted: map['is_completed'] ?? false,
      orderIndex: map['order_index'],
    );
  }
}
