import 'dart:io';
import 'package:avatar_flow/core/config/appconfig.dart';
import 'package:avatar_flow/core/services/supabase_client.dart';
import 'package:avatar_flow/features/avatar/models/eleven_labs_voice_model.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;

class VoiceCloneService {
  late final Dio _dio;

  VoiceCloneService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: "https://api.elevenlabs.io/v1",
        headers: {"xi-api-key": AppConfig.elevenLabsApiKey},
        responseType: ResponseType.json,
      ),
    );
  }

  /// Fetch all available voices from ElevenLabs
  Future<List<ElevenLabsVoice>> fetchVoices() async {
    try {
      final response = await _dio.get("/voices");

      if (response.statusCode == 200) {
        final voicesData = response.data['voices'] as List<dynamic>;
        return voicesData
            .map(
              (voice) =>
                  ElevenLabsVoice.fromJson(voice as Map<String, dynamic>),
            )
            .toList();
      }

      return [];
    } on DioException catch (e) {
      print("Fetch voices error: ${e.response?.data}");
      return [];
    } catch (e) {
      print("Unexpected error fetching voices: $e");
      return [];
    }
  }

  /// Fetch a single voice by its ID — returns null if not found or on error
  Future<ElevenLabsVoice?> fetchVoiceById(String voiceId) async {
    try {
      final response = await _dio.get("/voices/$voiceId");
      if (response.statusCode == 200) {
        return ElevenLabsVoice.fromJson(response.data as Map<String, dynamic>);
      }
      return null;
    } on DioException catch (e) {
      print("Fetch voice by id error: ${e.response?.data}");
      return null;
    } catch (e) {
      print("Unexpected error fetching voice by id: $e");
      return null;
    }
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

  // --- FAVORITES LOGIC ---

  /// Fetch IDs of favorite voices for the current user
  Future<List<String>> fetchFavoriteVoiceIds() async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await supabase.from('favorite_voices').select('voice_id');

      return (response as List)
          .map((item) => item['voice_id'] as String)
          .toList();
    } catch (e) {
      print("Error fetching favorite voices: $e");
      return [];
    }
  }

  /// Add a voice to favorites
  Future<void> addFavoriteVoice(String voiceId) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      await supabase.from('favorite_voices').upsert({
        'user_id': userId,
        'voice_id': voiceId,
      });
    } catch (e) {
      print("Error adding favorite voice: $e");
    }
  }

  /// Remove a voice from favorites
  Future<void> removeFavoriteVoice(String voiceId) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return;

      await supabase
          .from('favorite_voices')
          .delete()
          .eq('user_id', userId)
          .eq('voice_id', voiceId);
    } catch (e) {
      print("Error removing favorite voice: $e");
    }
  }
}
