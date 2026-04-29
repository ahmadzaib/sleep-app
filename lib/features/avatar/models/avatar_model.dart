import 'package:avatar_flow/features/avatar/models/trait_model.dart';

class AvatarModel {
  final int? id;
  final DateTime? createdAt;
  final String name;
  final String gender;
  final List<TraitModel> traits;
  final String avatarUrl;
  final String? voiceId;
  final String? userId;
  final bool voiceTerm;
  final int shareCount;
  final int storiesCount;
  final String? color;

  AvatarModel({
    this.id,
    this.createdAt,
    required this.name,
    required this.gender,
    required this.traits,
    required this.avatarUrl,
    required this.voiceTerm,
    this.shareCount = 0,
    this.storiesCount = 0,
    this.color,
    this.voiceId,
    this.userId,
  });

  /// FROM JSON
  factory AvatarModel.fromJson(Map<String, dynamic> json) {
    return AvatarModel(
      id: json['id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      voiceTerm: json['voice_term'] ?? false,
      traits:
          (json['traits'] as List<dynamic>?)
              ?.map((e) => TraitModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      avatarUrl: json['avatar_url'] ?? '',
      voiceId: json['voice_id'],
      userId: json['user_id'] ?? '',
      shareCount: json['share_count'] ?? 0,
      storiesCount: json['stories_count'] ?? 0,
      color: json['color'] as String?,
    );
  }

  /// TO JSON (for Supabase insert/update)
  /// NOTE: traits are NOT included - they go to avatar_traits junction table separately
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'name': name,
      'gender': gender,
      'avatar_url': avatarUrl,
      'voice_id': voiceId,
      'user_id': userId,
      'voice_term': voiceTerm,
      'share_count': shareCount,
      'stories_count': storiesCount,
      'color': color,
    };
    if (id != null) data['id'] = id;
    return data;
  }

  /// COPY WITH
  AvatarModel copyWith({
    int? id,
    DateTime? createdAt,
    String? name,
    String? gender,
    List<TraitModel>? traits,
    String? avatarUrl,
    String? voiceUrl,
    String? userId,
    bool? voiceTerm,
    int? shareCount,
    int? storiesCount,
    String? color,
  }) {
    return AvatarModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      traits: traits ?? this.traits,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      voiceId: voiceUrl ?? voiceId,
      userId: userId ?? this.userId,
      voiceTerm: voiceTerm ?? this.voiceTerm,
      shareCount: shareCount ?? this.shareCount,
      storiesCount: storiesCount ?? this.storiesCount,
      color: color ?? this.color,
    );
  }
}
