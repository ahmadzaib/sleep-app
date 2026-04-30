import 'package:avatar_flow/core/debug/debug_point.dart';

/// Story model for avatar stories
/// Each story belongs to an avatar and contains content with images
class Story {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int avatarId;
  final String title;
  final String? description;
  final String content;
  final List<String> images;
  final double rating;
  final bool isDeleted;

  Story({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.avatarId,
    required this.title,
    this.description,
    required this.content,
    this.images = const [],
    this.rating = 5.0,
    this.isDeleted = false,
  });

  /// Create from Supabase JSON
  factory Story.fromJson(Map<String, dynamic> json) {
    try {
      return Story(
        id: json['id'] as int?,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'] as String)
            : null,
        avatarId: json['avatar_id'] as int,
        title: json['title'] as String,
        description: json['description'] as String?,
        content: json['content'] as String,
        images:
            (json['images'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
        isDeleted: json['is_deleted'] as bool? ?? false,
      );
    } catch (e) {
      DebugPoint.error('Error parsing Story: $e');
      rethrow;
    }
  }

  /// Convert to Supabase JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar_id': avatarId,
      'title': title,
      'description': description,
      'content': content,
      'images': images,
      'rating': rating,
      'is_deleted': isDeleted,
    };
  }

  /// Create a copy with updated fields
  Story copyWith({
    int? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? avatarId,
    String? title,
    String? description,
    String? content,
    List<String>? images,
    double? rating,
    bool? isDeleted,
  }) {
    return Story(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      avatarId: avatarId ?? this.avatarId,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  /// Get the first image URL or empty string
  String get firstImageUrl => images.isNotEmpty ? images.first : '';

  /// Check if story has images
  bool get hasImages => images.isNotEmpty;

  /// Get formatted rating string
  String get ratingString => rating.toStringAsFixed(1);

  /// Get author display name (for UI compatibility)
  String get author => 'Avatar Story';

  /// Get image URL for UI compatibility
  String get imageUrl => firstImageUrl;

  @override
  String toString() => 'Story(id: $id, title: $title, avatarId: $avatarId)';
}
