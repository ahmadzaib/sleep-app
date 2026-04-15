import 'dart:io';
import 'package:avatar_flow/core/utils/image_picker_helper.dart';
import 'package:avatar_flow/features/prompt_ai/models/chat_model.dart';
import 'package:flutter/material.dart';

class PromptAiProvider extends ChangeNotifier {
  final TextEditingController promptController = TextEditingController();

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void updatePrompt(String val) {
    notifyListeners();
  }

  void setImage(File? file) {
    _selectedImage = file;
    notifyListeners();
  }

  Future<void> pickImageFromGalleryAndSend() async {
    final file = await ImagePickerHelper.pickFromGallery();
    if (file == null) return;

    _selectedImage = file;
    await sendMessage();
  }

  Future<void> pickImageFromCameraAndSend() async {
    final file = await ImagePickerHelper.pickFromCamera();
    if (file == null) return;

    _selectedImage = file;
    await sendMessage();
  }

  /// SEND USER MESSAGE
  Future<void> sendMessage() async {
    final text = promptController.text.trim();

    if (text.isEmpty && _selectedImage == null) return;

    // 1. Add user message
    _messages.add(
      ChatMessage(
        text: text.isEmpty ? null : text,
        imagePath: _selectedImage?.path,
        isUser: true,
        time: DateTime.now(),
      ),
    );

    promptController.clear();
    final image = _selectedImage;
    _selectedImage = null;

    _isLoading = true;
    notifyListeners();

    // 2. Simulate AI delay
    await Future.delayed(const Duration(seconds: 2));

    // 3. Fake AI response (replace with API later)
    _messages.add(
      ChatMessage(
        imagePath: image?.path,
        text: image != null
            ? "I received your image. Here is my analysis ✨"
            : "You said: $text",
        isUser: false,
        time: DateTime.now(),
      ),
    );

    _isLoading = false;
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }
}
