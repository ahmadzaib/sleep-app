class TraitModel {
  final int id;
  final String name;
  final String? imageUrl;

  TraitModel({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  factory TraitModel.fromJson(Map<String, dynamic> json) {
    return TraitModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
    };
  }

  TraitModel copyWith({
    int? id,
    String? name,
    String? imageUrl,
  }) {
    return TraitModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
