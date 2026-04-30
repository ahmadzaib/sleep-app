import 'dart:io';
import 'package:avatar_flow/core/services/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

class SupabaseStorageService {
  static final SupabaseClient _client = supabase;

  static Future<String?> uploadImage({
    required File file,
    required String bucketName,
    String folder = 'uploads',
  }) async {
    try {
      final fileExt = path.extension(file.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExt';
      final filePath = '$folder/$fileName';

      await _client.storage
          .from(bucketName)
          .upload(
            filePath,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      return _client.storage.from(bucketName).getPublicUrl(filePath);
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }

  static Future<void> deleteImage({
    required String bucketName,
    required String filePath,
  }) async {
    try {
      await _client.storage.from(bucketName).remove([filePath]);
    } catch (e) {
      print('Delete error: $e');
    }
  }
}
