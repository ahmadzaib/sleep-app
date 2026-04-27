import 'dart:io';

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
      final tempDir = await getTemporaryDirectory();
      final name =
          fileName ?? 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savePath = '${tempDir.path}/$name';

      await _dio.download(imageUrl, savePath);
      return savePath;
    } catch (e) {
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
      return await _dio.post(
        url,
        data: data,
        options: Options(headers: headers),
      );
    } catch (e) {
      return null;
    }
  }

  /// GET request helper
  Future<Response?> get(String url, {Map<String, String>? headers}) async {
    try {
      return await _dio.get(url, options: Options(headers: headers));
    } catch (e) {
      return null;
    }
  }
}
