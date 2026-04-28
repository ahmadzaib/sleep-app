import 'dart:io';

import 'package:avatar_flow/core/config/appconfig.dart';
import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/core/dio/dio_client.dart';
import 'package:dio/dio.dart';

/// Service for removing image backgrounds using remove.bg API
class BackgroundRemovalService {
  final DioClient _dioClient;

  BackgroundRemovalService(this._dioClient);

  /// Remove image background using remove.bg API
  /// Returns path to the new image with transparent background, or null on failure
  Future<String?> removeBackground(File imageFile) async {
    try {
      final apiKey = AppConfig.removeBgApiKey;
      if (apiKey.isEmpty) {
        DebugPoint.log('remove.bg API key not configured, skipping BG removal');
        return null;
      }

      final formData = FormData.fromMap({
        'image_file': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'avatar_image.png',
        ),
        'size': 'preview',
      });

      DebugPoint.log('Calling remove.bg API...');
      final response = await _dioClient.dio.post(
        AppConfig.removeBgEndpoint,
        data: formData,
        options: Options(
          headers: {'X-Api-Key': apiKey},
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        // Save the PNG with transparent background
        final tempDir = await Directory.systemTemp.createTemp();
        final outputPath =
            '${tempDir.path}/avatar_nobg_${DateTime.now().millisecondsSinceEpoch}.png';
        final outputFile = File(outputPath);
        await outputFile.writeAsBytes(response.data);

        final fileSize = await outputFile.length();
        DebugPoint.log('BG removed image saved: $outputPath ($fileSize bytes)');
        return outputPath;
      } else {
        DebugPoint.error('remove.bg failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      DebugPoint.error('remove.bg API error: $e');
      return null;
    }
  }
}
