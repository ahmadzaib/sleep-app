class AvatarModel {
  final int? id;
  final DateTime? createdAt;
  final String name;
  final String gender;
  final List<String> traits;
  final String avatarUrl;
  final String? voiceUrl;
  final String userId;

  AvatarModel({
    this.id,
    this.createdAt,
    required this.name,
    required this.gender,
    required this.traits,
    required this.avatarUrl,
    this.voiceUrl,
    required this.userId,
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
      traits: List<String>.from(json['traits'] ?? []),
      avatarUrl: json['avatar_url'] ?? '',
      voiceUrl: json['voice_url'],
      userId: json['user_id'] ?? '',
    );
  }

  /// TO JSON (for Supabase insert/update)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'name': name,
      'gender': gender,
      'traits': traits,
      'avatar_url': avatarUrl,
      'voice_url': voiceUrl,
      'user_id': userId,
    };
  }

  /// COPY WITH
  AvatarModel copyWith({
    int? id,
    DateTime? createdAt,
    String? name,
    String? gender,
    List<String>? traits,
    String? avatarUrl,
    String? voiceUrl,
    String? userId,
  }) {
    return AvatarModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      traits: traits ?? this.traits,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      voiceUrl: voiceUrl ?? this.voiceUrl,
      userId: userId ?? this.userId,
    );
  }
}
