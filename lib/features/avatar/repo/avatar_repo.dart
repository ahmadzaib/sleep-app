import 'package:avatar_flow/core/constants/db_constants.dart';
import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/features/avatar/models/avatar_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvatarRepo {
  final SupabaseClient _client = Supabase.instance.client;

  static const String _table = DBConstansts.avatars;

  /// CREATE
  Future<AvatarModel> createAvatar(AvatarModel avatar) async {
    final userId = _client.auth.currentUser?.id;
    final session = _client.auth.currentSession;

    if (session == null) {
      DebugPoint.log("No session → ANON user");
    } else {
      DebugPoint.log("Authenticated user");
      DebugPoint.log("User ID: ${session.user.id}");
    }

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final data = avatar.copyWith(userId: userId).toJson();

    final response = await _client.from(_table).insert(data).select().single();

    return AvatarModel.fromJson(response);
  }

  /// GET ALL (current user)
  Future<List<AvatarModel>> getMyAvatars() async {
    final userId = _client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    final response = await _client
        .from(_table)
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (response as List).map((e) => AvatarModel.fromJson(e)).toList();
  }

  /// GET BY ID
  Future<AvatarModel?> getAvatarById(int id) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;

    return AvatarModel.fromJson(response);
  }

  /// UPDATE
  Future<AvatarModel> updateAvatar(AvatarModel avatar) async {
    if (avatar.id == null) {
      throw Exception('Avatar ID is required for update');
    }

    final response = await _client
        .from(_table)
        .update(avatar.toJson())
        .eq('id', avatar.id!)
        .select()
        .single();

    return AvatarModel.fromJson(response);
  }

  /// DELETE
  Future<bool> deleteAvatar(int id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
