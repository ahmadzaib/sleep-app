import 'dart:io';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/utils/image_picker_helper.dart';
import 'package:avatar_flow/features/prompt_ai/models/chat_model.dart';
import 'package:flutter/material.dart';

class PromptAiProvider extends ChangeNotifier {
  static const List<String> peopleOptions = [
    AppImagesPng.dummyImage,
    AppImagesPng.dummyImage,
    AppImagesPng.dummyImage,
    AppImagesPng.dummyImage,
    AppImagesPng.dummyImage,
    AppImagesPng.dummyImage,
  ];

  static const List<Map<String, String>> styleOptions = [
    {'name': 'Vector 3D', 'image': AppImagesPng.vector3d},
    {'name': 'Cartoon', 'image': AppImagesPng.cartoon},
    {'name': 'Special', 'image': AppImagesPng.special},
  ];

  final TextEditingController promptController = TextEditingController();

  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  // Single selected image - can be File (picked) or String (asset path from person grid)
  dynamic _selectedImage;
  dynamic get selectedImage => _selectedImage;
  bool get hasSelectedImage => _selectedImage != null;
  bool get isAssetImage => _selectedImage != null && _selectedImage is String;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _selectedStyle;
  String? get selectedStyle => _selectedStyle;

  void setSelectedPerson(String imagePath) {
    _selectedImage = imagePath;
    notifyListeners();
  }

  void setSelectedStyle(String? styleName) {
    _selectedStyle = styleName;
    notifyListeners();
  }

  void updatePrompt(String val) {
    notifyListeners();
  }

  void clearSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }

  Future<void> pickImageFromGallery() async {
    final file = await ImagePickerHelper.pickFromGallery();
    if (file == null) return;

    _selectedImage = file;
    notifyListeners();
  }

  Future<void> pickImageFromCamera() async {
    final file = await ImagePickerHelper.pickFromCamera();
    if (file == null) return;

    _selectedImage = file;
    notifyListeners();
  }

  /// SEND USER MESSAGE
  Future<void> sendMessage() async {
    final text = promptController.text.trim();

    if (text.isEmpty && _selectedImage == null) return;

    // Capture values before clearing
    final image = _selectedImage;
    final style = _selectedStyle;
    final isAsset = _selectedImage is String;

    // 1. Add user message with image and style
    _messages.add(
      ChatMessage(
        text: text.isEmpty ? null : text,
        imagePath: isAsset ? _selectedImage : (_selectedImage as File?)?.path,
        isAssetImage: isAsset,
        style: style,
        isUser: true,
        time: DateTime.now(),
      ),
    );

    promptController.clear();
    _selectedImage = null;
    _selectedStyle = null;

    _isLoading = true;
    notifyListeners();

    // 2. Simulate AI delay
    await Future.delayed(const Duration(seconds: 2));

    // 3. Fake AI response (replace with API later)
    _messages.add(
      ChatMessage(
        imagePath: isAsset ? image : (image as File?)?.path,
        isAssetImage: isAsset,
        style: style,
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
