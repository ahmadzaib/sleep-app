import 'package:avatar_flow/features/avatar/models/avatar_model.dart';

class SharedAvatarModel {
  final int id;
  final DateTime createdAt;
  final int avatarId;
  final String sharedWithUserId;

  /// The full avatar object — populated after a join/second fetch
  final AvatarModel? avatar;

  SharedAvatarModel({
    required this.id,
    required this.createdAt,
    required this.avatarId,
    required this.sharedWithUserId,
    this.avatar,
  });

  factory SharedAvatarModel.fromJson(Map<String, dynamic> json) {
    return SharedAvatarModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      avatarId: json['avatar_id'] as int,
      sharedWithUserId: json['shared_with_user_id'] as String,
    );
  }

  SharedAvatarModel copyWith({AvatarModel? avatar}) {
    return SharedAvatarModel(
      id: id,
      createdAt: createdAt,
      avatarId: avatarId,
      sharedWithUserId: sharedWithUserId,
      avatar: avatar ?? this.avatar,
    );
  }
}
