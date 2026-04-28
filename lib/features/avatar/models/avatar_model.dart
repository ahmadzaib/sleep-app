class AvatarModel {
  final int? id;
  final DateTime? createdAt;
  final String name;
  final String gender;
  final List<String> traits;
  final String avatarUrl;
  final String? voiceId;
  final String? userId;
  final bool voiceTerm;
  final int shareCount;

  AvatarModel({
    this.id,
    this.createdAt,
    required this.name,
    required this.gender,
    required this.traits,
    required this.avatarUrl,
    required this.voiceTerm,
    this.shareCount = 0,
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
      traits: List<String>.from(json['traits'] ?? []),
      avatarUrl: json['avatar_url'] ?? '',
      voiceId: json['voice_id'],
      userId: json['user_id'] ?? '',
      shareCount: json['share_count'] ?? 0,
    );
  }

  /// TO JSON (for Supabase insert/update)
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'name': name,
      'gender': gender,
      'traits': traits,
      'avatar_url': avatarUrl,
      'voice_id': voiceId,
      'user_id': userId,
      'voice_term': voiceTerm,
      'share_count': shareCount,
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
    List<String>? traits,
    String? avatarUrl,
    String? voiceUrl,
    String? userId,
    bool? voiceTerm,
    int? shareCount,
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
    );
  }
}
