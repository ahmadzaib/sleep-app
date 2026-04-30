import 'package:avatar_flow/core/constants/db_constants.dart';
import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/features/avatar/models/story_model.dart';
import 'package:avatar_flow/core/services/supabase_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoryRepo {
  final SupabaseClient _client = supabase;

  static const String _table = DBConstansts.stories;

  /// CREATE - Only avatar owner can create stories
  Future<Story> createStory(Story story) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // Remove id for insert (auto-generated)
    final data = story.toJson()..remove('id');

    final response = await _client.from(_table).insert(data).select().single();

    final createdStory = Story.fromJson(response);
    DebugPoint.log(
      'Created story ${createdStory.id} for avatar ${story.avatarId}',
    );
    return createdStory;
  }

  /// GET ALL stories for an avatar - Accessible by owner and shared users
  Future<List<Story>> getStoriesByAvatarId(int avatarId) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('avatar_id', avatarId)
        .eq('is_deleted', false)
        .order('created_at', ascending: false);

    final stories = (response as List).map((e) => Story.fromJson(e)).toList();
    DebugPoint.log('Fetched ${stories.length} stories for avatar $avatarId');
    return stories;
  }

  /// GET a single story by ID
  Future<Story?> getStoryById(int storyId) async {
    final response = await _client
        .from(_table)
        .select()
        .eq('id', storyId)
        .eq('is_deleted', false)
        .maybeSingle();

    if (response == null) return null;
    return Story.fromJson(response);
  }

  /// UPDATE - Only avatar owner can update stories
  Future<Story> updateStory(Story story) async {
    if (story.id == null) throw Exception('Story ID is required for update');

    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');

    // Remove immutable fields
    final data = story.toJson()
      ..remove('id')
      ..remove('created_at')
      ..remove('avatar_id'); // Prevent changing avatar ownership

    final response = await _client
        .from(_table)
        .update(data)
        .eq('id', story.id!)
        .select()
        .single();

    final updatedStory = Story.fromJson(response);
    DebugPoint.log('Updated story ${updatedStory.id}');
    return updatedStory;
  }

  /// DELETE (soft delete) - Only avatar owner can delete
  Future<bool> deleteStory(int storyId) async {
    try {
      await _client.from(_table).update({'is_deleted': true}).eq('id', storyId);

      DebugPoint.log('Soft deleted story $storyId');
      return true;
    } catch (e) {
      DebugPoint.error('Failed to delete story: $e');
      return false;
    }
  }

  /// Check if user can access stories for an avatar (owner or shared)
  Future<bool> canAccessStories(int avatarId, String userId) async {
    try {
      // Check if user is the owner
      final avatarResponse = await _client
          .from(DBConstansts.avatars)
          .select('user_id')
          .eq('id', avatarId)
          .maybeSingle();

      if (avatarResponse != null && avatarResponse['user_id'] == userId) {
        return true;
      }

      // Check if avatar is shared with user
      final shareResponse = await _client
          .from(DBConstansts.sharedAvatars)
          .select()
          .eq('avatar_id', avatarId)
          .eq('shared_with_user_id', userId)
          .maybeSingle();

      return shareResponse != null;
    } catch (e) {
      DebugPoint.error('Error checking story access: $e');
      return false;
    }
  }
}
