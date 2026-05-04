class ElevenLabsVoice {
  final String voiceId;
  final String name;
  final List<String> labels;
  final String? previewUrl;

  ElevenLabsVoice({
    required this.voiceId,
    required this.name,
    required this.labels,
    this.previewUrl,
  });

  factory ElevenLabsVoice.fromJson(Map<String, dynamic> json) {
    return ElevenLabsVoice(
      voiceId: json['voice_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      labels: (json['labels'] as Map<String, dynamic>?)?.values
              .map((e) => e.toString())
              .toList() ??
          [],
      previewUrl: json['preview_url'],
    );
  }
}
