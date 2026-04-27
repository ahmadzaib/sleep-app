class ChatMessage {
  final String? text;
  final String? imagePath;
  final String? imageUrl;
  final bool isAssetImage;
  final String? style;
  final bool isUser;
  final DateTime time;

  ChatMessage({
    this.text,
    this.imagePath,
    this.imageUrl,
    this.isAssetImage = false,
    this.style,
    required this.isUser,
    required this.time,
  });

  bool get hasImage => imagePath != null || imageUrl != null;
}
