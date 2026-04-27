import 'dart:io';

import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

/// Simple Dio client for direct API calls (Gemini, ElevenLabs)
/// No auth - just direct API integration
class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(minutes: 2),
        receiveTimeout: const Duration(minutes: 2),
        sendTimeout: const Duration(minutes: 2),
      ),
    );
  }

  Dio get dio => _dio;

  /// Download image from URL and save to local file
  Future<String?> downloadImage(String imageUrl, {String? fileName}) async {
    try {
      DebugPoint.log('Downloading image from: $imageUrl');

      final tempDir = await getTemporaryDirectory();
      final name =
          fileName ?? 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savePath = '${tempDir.path}/$name';

      DebugPoint.log('Saving to: $savePath');

      final response = await _dio.download(imageUrl, savePath);

      DebugPoint.log('Download response status: ${response.statusCode}');
      DebugPoint.log('Image saved successfully');

      return savePath;
    } catch (e) {
      DebugPoint.error('Failed to download image: $e');
      return null;
    }
  }

  /// POST request helper
  Future<Response?> post(
    String url, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    try {
      DebugPoint.log('POST request to: $url');
      DebugPoint.debug('Request data: $data');

      final response = await _dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );

      DebugPoint.log('POST response status: ${response.statusCode}');
      return response;
    } catch (e) {
      DebugPoint.error('POST request failed: $e');
      return null;
    }
  }

  /// GET request helper
  Future<Response?> get(String url, {Map<String, String>? headers}) async {
    try {
      DebugPoint.log('GET request to: $url');

      final response = await _dio.get(url, options: Options(headers: headers));

      DebugPoint.log('GET response status: ${response.statusCode}');
      return response;
    } catch (e) {
      DebugPoint.error('GET request failed: $e');
      return null;
    }
  }
}
