import 'package:avatar_flow/features/auth/models/user_model.dart';
import 'package:avatar_flow/features/avatar/repo/avatar_repo.dart';
import 'package:flutter/material.dart';

class AvatarShareProvider extends ChangeNotifier {
  final AvatarRepo _avatarRepo = AvatarRepo();

  List<UserModel> _recipients = [];
  List<UserModel> get recipients => _recipients;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<UserModel> _searchResults = [];
  List<UserModel> get searchResults => _searchResults;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  List<UserModel> _suggestedUsers = [];
  List<UserModel> get suggestedUsers => _suggestedUsers;

  /// Fetch users this avatar is shared with
  Future<void> fetchRecipients(int avatarId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _recipients = await _avatarRepo.getSharedWithUsers(avatarId);
    } catch (e) {
      _recipients = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Remove a specific user's access
  Future<void> revokeShare(int avatarId, String userId) async {
    try {
      await _avatarRepo.revokeShare(avatarId, userId);
      _recipients.removeWhere((u) => u.id == userId);
      notifyListeners();
    } catch (e) {
      // Error handling
    }
  }

  /// Remove all users' access
  Future<void> revokeAll(int avatarId) async {
    try {
      await _avatarRepo.revokeAllShares(avatarId);
      _recipients.clear();
      notifyListeners();
    } catch (e) {
      // Error handling
    }
  }

  /// Fetch suggested users (initial list)
  Future<void> fetchSuggestions() async {
    _isSearching = true;
    notifyListeners();
    try {
      _suggestedUsers = await _avatarRepo.searchUsers(''); // Search with empty string to get recent/random users
    } catch (e) {
      _suggestedUsers = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  /// SEARCH for users
  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    _isSearching = true;
    notifyListeners();
    try {
      _searchResults = await _avatarRepo.searchUsers(query);
    } catch (e) {
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  /// SHARE with a user
  Future<void> shareAvatar(int avatarId, String targetUserId) async {
    try {
      await _avatarRepo.shareAvatar(avatarId, targetUserId);
      // Refresh recipients list after sharing
      await fetchRecipients(avatarId);
    } catch (e) {
      // Error handling
    }
  }
}
