import 'package:avatar_flow/core/constants/db_constants.dart';
import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/features/avatar/models/avatar_model.dart';
import 'package:avatar_flow/features/avatar/models/trait_model.dart';
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

    final createdAvatar = AvatarModel.fromJson(response);

    // Insert traits into avatar_traits junction table if avatar has traits
    if (createdAvatar.id != null && avatar.traits.isNotEmpty) {
      await _updateAvatarTraits(createdAvatar.id!, avatar.traits);
      DebugPoint.log(
        'Created avatar ${createdAvatar.id} with ${avatar.traits.length} traits',
      );
    }

    return createdAvatar;
  }

  /// GET ALL (current user) with traits
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

    final avatars = (response as List)
        .map((e) => AvatarModel.fromJson(e))
        .toList();

    // Fetch traits for each avatar
    final result = <AvatarModel>[];
    for (final avatar in avatars) {
      if (avatar.id != null) {
        final traits = await _getAvatarTraits(avatar.id!);
        result.add(avatar.copyWith(traits: traits));
        DebugPoint.log('Avatar ${avatar.name} traits: $traits');
      } else {
        result.add(avatar);
      }
    }

    return result;
  }

  /// GET BY ID with traits
  Future<AvatarModel?> getAvatarById(int id) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;

    var avatar = AvatarModel.fromJson(response);
    final traits = await _getAvatarTraits(id);
    avatar = avatar.copyWith(traits: traits);

    return avatar;
  }

  /// GET traits for avatar from avatar_traits junction table
  Future<List<TraitModel>> _getAvatarTraits(int avatarId) async {
    DebugPoint.log('Fetching traits for avatar_id: $avatarId');

    // Get trait_ids from avatar_traits junction table
    final junctionResponse = await _client
        .from(DBConstansts.avatarTraits)
        .select('trait_id')
        .eq('avatar_id', avatarId);

    DebugPoint.log('Junction response: $junctionResponse');

    if (junctionResponse.isEmpty) return [];

    final traitIds = junctionResponse
        .map((e) => e['trait_id'] as int?)
        .where((id) => id != null)
        .cast<int>()
        .toList();

    if (traitIds.isEmpty) return [];

    // Fetch trait names and image_urls from traits table
    final traitsResponse = await _client
        .from(DBConstansts.traits)
        .select('id, name, image_url')
        .inFilter('id', traitIds);

    DebugPoint.log('Traits response: $traitsResponse');

    return traitsResponse.map((e) => TraitModel.fromJson(e)).toList();
  }

  /// UPDATE
  Future<AvatarModel> updateAvatar(AvatarModel avatar) async {
    if (avatar.id == null) {
      throw Exception('Avatar ID is required for update');
    }

    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Only update mutable fields — never overwrite user_id with null
    final data = {
      'name': avatar.name,
      'gender': avatar.gender,
      'avatar_url': avatar.avatarUrl,
      'voice_id': avatar.voiceId,
      'voice_term': avatar.voiceTerm,
    };

    final response = await _client
        .from(_table)
        .update(data)
        .eq('id', avatar.id!)
        .eq('user_id', userId) // safety: only update own avatars
        .select()
        .single();

    // Update traits in avatar_traits junction table
    await _updateAvatarTraits(avatar.id!, avatar.traits);

    return AvatarModel.fromJson(response);
  }

  /// Update traits in avatar_traits junction table
  Future<void> _updateAvatarTraits(
    int avatarId,
    List<TraitModel> traits,
  ) async {
    // Delete existing traits for this avatar
    await _client
        .from(DBConstansts.avatarTraits)
        .delete()
        .eq('avatar_id', avatarId);

    if (traits.isEmpty) return;

    // Get trait_ids from traits table by name
    final traitNames = traits.map((t) => t.name).toList();
    final traitsResponse = await _client
        .from(DBConstansts.traits)
        .select('id, name')
        .inFilter('name', traitNames);

    final traitIdMap = <String, int>{};
    for (final row in traitsResponse) {
      final id = row['id'] as int?;
      final name = row['name'] as String?;
      if (id != null && name != null) {
        traitIdMap[name] = id;
      }
    }

    // Insert new trait associations
    final inserts = <Map<String, dynamic>>[];
    for (final trait in traits) {
      final traitId = traitIdMap[trait.name];
      if (traitId != null) {
        inserts.add({'avatar_id': avatarId, 'trait_id': traitId});
      }
    }

    if (inserts.isNotEmpty) {
      await _client.from(DBConstansts.avatarTraits).insert(inserts);
    }
  }

  /// DELETE
  Future<bool> deleteAvatar(int id) async {
    try {
      // First delete traits from junction table (foreign key constraint safety)
      await _client
          .from(DBConstansts.avatarTraits)
          .delete()
          .eq('avatar_id', id);

      // Then delete the avatar
      await _client.from(_table).delete().eq('id', id);
      return true;
    } catch (e) {
      DebugPoint.error('Failed to delete avatar: $e');
      return false;
    }
  }

  /// GET ALL traits from traits table
  Future<List<TraitModel>> getAllTraits() async {
    final response = await _client
        .from(DBConstansts.traits)
        .select('id, name, image_url')
        .order('name', ascending: true);

    return (response as List).map((e) => TraitModel.fromJson(e)).toList();
  }
}
