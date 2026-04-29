import 'dart:io';
import 'package:avatar_flow/core/config/appconfig.dart';
import 'package:dio/dio.dart';

class VoiceCloneService {
  late final Dio _dio;

  VoiceCloneService({r}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://api.elevenlabs.io/v1",
        headers: {"xi-api-key": AppConfig.elevenLabsApiKey},
        responseType: ResponseType.json,
      ),
    );
  }

  /// 1. Clone Voice → returns voice_id
  Future<String?> cloneVoice({
    required String name,
    required File audioFile,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        "name": name,
        "files": await MultipartFile.fromFile(
          audioFile.path,
          filename: audioFile.path.split('/').last,
        ),
      });

      final response = await _dio.post("/voices/add", data: formData);

      if (response.statusCode == 200) {
        return response.data["voice_id"];
      }

      return null;
    } on DioException catch (e) {
      print("Clone error: ${e.response?.data}");
      return null;
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }

  /// 2. Text to Speech → returns audio bytes
  Future<List<int>?> textToSpeech({
    required String voiceId,
    required String text,
  }) async {
    try {
      final response = await _dio.post(
        "/text-to-speech/$voiceId",
        data: {"text": text, "model_id": "eleven_multilingual_v2"},
        options: Options(
          responseType: ResponseType.bytes,
          headers: {"Content-Type": "application/json", "Accept": "audio/mpeg"},
        ),
      );

      if (response.statusCode == 200) {
        return response.data; // audio bytes
      }

      return null;
    } on DioException catch (e) {
      print("TTS error: ${e.response?.data}");
      return null;
    } catch (e) {
      print("Unexpected error: $e");
      return null;
    }
  }
}
