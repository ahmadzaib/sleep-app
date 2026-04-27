import 'dart:convert';
import 'dart:io';
import 'package:avatar_flow/core/config/appconfig.dart';
import 'package:avatar_flow/core/constants/app_images.dart';
import 'package:avatar_flow/core/debug/debug_point.dart';
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

  /// Get API config from AppConfig (accessed at runtime, not class load time)
  static String get _geminiApiKey => AppConfig.geminiApiKey;
  static String get _geminiEndpoint => AppConfig.geminiEndpoint;
  static String get _pollinationsEndpoint => AppConfig.pollinationsEndpoint;

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

    String? generatedImagePath;

    try {
      // 2. Call Pollinations AI for image generation
      // Returns local file path to the downloaded image
      generatedImagePath = await _callPollinationsApi(
        prompt: text,
        style: style,
        imagePath: isAsset ? image : (image as File?)?.path,
        isAsset: isAsset,
      );

      DebugPoint.log('Generated image path for chat: $generatedImagePath');
    } catch (e) {
      DebugPoint.error('Error generating image: $e');
    } finally {
      // 3. AI response with generated image (local file path only)
      // Upload to storage happens in CreateAvatarProvider when avatar is created
      _messages.add(
        ChatMessage(
          imagePath: generatedImagePath,
          isAssetImage: false,
          style: style,
          text: generatedImagePath != null
              ? "Here's your generated image based on your prompt ✨"
              : "Failed to generate image. Please try again.",
          isUser: false,
          time: DateTime.now(),
        ),
      );

      _isLoading = false;
      notifyListeners();
    }
  }

  /// Call Pollinations AI for image generation
  /// Returns local file path to downloaded image
  Future<String?> _callPollinationsApi({
    required String prompt,
    String? style,
    String? imagePath,
    bool isAsset = false,
  }) async {
    try {
      DebugPoint.log('Calling Pollinations AI API');

      // Build prompt with style - embed full body cartoon style for avatar generation
      final basePrompt = '$prompt, full body, cartoon style';
      final fullPrompt = style != null
          ? '$basePrompt in $style style'
          : basePrompt;

      // URL encode the prompt
      final encodedPrompt = Uri.encodeComponent(fullPrompt);

      // Build URL with parameters (no API key needed for basic use)
      final url =
          '$_pollinationsEndpoint/$encodedPrompt?width=1024&height=1024&seed=${DateTime.now().millisecond}&nologo=true';

      DebugPoint.log('Prompt: $fullPrompt');
      DebugPoint.log('Request URL: $url');

      final dio = DioClient();

      // Download image directly from Pollinations
      final savePath = await dio.downloadImage(
        url,
        fileName: 'pollinations_${DateTime.now().millisecondsSinceEpoch}.png',
      );

      if (savePath != null) {
        DebugPoint.log('Image downloaded successfully to: $savePath');
      } else {
        DebugPoint.error('Failed to download image from Pollinations');
      }

      return savePath;
    } catch (e) {
      DebugPoint.error('Pollinations API exception: $e');
      ToastUtils.error('Image generation failed: $e');
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
