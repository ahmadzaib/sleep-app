class ChatMessage {
  final String? text;
  final String? imagePath;
  final String? imageUrl;
  final bool isUser;
  final DateTime time;

  ChatMessage({
    this.text,
    this.imagePath,
    this.imageUrl,
    required this.isUser,
    required this.time,
  });
}
