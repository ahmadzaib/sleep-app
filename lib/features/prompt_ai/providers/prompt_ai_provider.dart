import 'dart:convert';
import 'dart:io';
import 'package:avatar_flow/core/config/appconfig.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/dio/dio_client.dart';
import 'package:avatar_flow/core/utils/image_picker_helper.dart';
import 'package:avatar_flow/core/utils/toast_utils.dart';
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

  /// Use API keys from AppConfig
  static const String _geminiApiKey = AppConfig.geminiApiKey;
  static const String _geminiEndpoint = AppConfig.geminiEndpoint;

  /// SEND USER MESSAGE - calls Gemini API
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

    // 2. Call Gemini API
    final generatedImageUrl = await _callGeminiApi(
      prompt: text,
      style: style,
      imagePath: isAsset ? image : (image as File?)?.path,
      isAsset: isAsset,
    );

    // 3. AI response with generated image
    _messages.add(
      ChatMessage(
        imageUrl: generatedImageUrl,
        isAssetImage: false,
        style: style,
        text: generatedImageUrl != null
            ? "Here's your generated image based on your prompt ✨"
            : "I'm working on that... (API key not configured)",
        isUser: false,
        time: DateTime.now(),
      ),
    );

    _isLoading = false;
    notifyListeners();
  }

  /// Call Gemini API for image generation
  Future<String?> _callGeminiApi({
    required String prompt,
    String? style,
    String? imagePath,
    bool isAsset = false,
  }) async {
    try {
      // Build prompt with style
      final fullPrompt = style != null
          ? 'Generate an image of $prompt in $style style'
          : 'Generate an image of $prompt';

      final dio = DioClient();
      final response = await dio.post(
        '$_geminiEndpoint?key=$_geminiApiKey',
        headers: {'Content-Type': 'application/json'},
        data: {
          'contents': [
            {
              'parts': [
                {'text': fullPrompt},
              ],
            },
          ],
          'generationConfig': {
            'responseModalities': ['Text', 'Image'],
          },
        },
      );

      if (response == null) return null;

      // Parse response - extract image URL from Gemini response
      final data = response.data;
      if (data['candidates'] != null && data['candidates'].isNotEmpty) {
        final parts = data['candidates'][0]['content']['parts'];
        for (final part in parts) {
          if (part['inlineData'] != null) {
            // Base64 encoded image
            final base64Image = part['inlineData']['data'];
            // Save base64 to file and return path
            return await _saveBase64Image(base64Image);
          }
        }
      }
      return null;
    } catch (e) {
      ToastUtils.error('API Error: $e');
      return null;
    }
  }

  /// Save base64 image to temp file
  Future<String?> _saveBase64Image(String base64String) async {
    try {
      final bytes = base64Decode(base64String);
      final tempDir = await Directory.systemTemp.createTemp();
      final file = File(
        '${tempDir.path}/generated_${DateTime.now().millisecondsSinceEpoch}.png',
      );
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      return null;
    }
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
