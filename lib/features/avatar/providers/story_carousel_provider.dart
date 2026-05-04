import 'package:avatar_flow/core/services/service_locator.dart';
import 'package:avatar_flow/features/avatar/models/story_model.dart';
import 'package:avatar_flow/features/avatar/repo/story_repo.dart';
import 'package:flutter/material.dart';

/// Provider for managing stories in the carousel view
/// Lightweight provider for avatar detail screen story cards
class StoryCarouselProvider extends ChangeNotifier {
  final StoryRepo _storyRepo = getIt<StoryRepo>();

  List<Story> _stories = [];
  List<Story> get stories => _stories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  int? _avatarId;
  int? get avatarId => _avatarId;

  /// Load stories for carousel (max 5 stories)
  Future<void> loadStories(int avatarId) async {
    // Clear if different avatar
    if (_avatarId != null && _avatarId != avatarId) {
      _stories = [];
    }

    _avatarId = avatarId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final allStories = await _storyRepo.getStoriesByAvatarId(avatarId);
      _stories = allStories.take(5).toList();
    } catch (e) {
      _error = 'Failed to load stories: $e';
      _stories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh stories for current avatar
  Future<void> refreshStories() async {
    if (_avatarId != null) {
      await loadStories(_avatarId!);
    }
  }

  /// Clear stories when leaving screen
  void clearStories() {
    _stories = [];
    _avatarId = null;
    _error = null;
    notifyListeners();
  }
}
