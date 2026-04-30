import 'package:avatar_flow/features/auth/models/user_model.dart';
import 'package:avatar_flow/features/avatar/repo/avatar_repo.dart';
import 'package:flutter/material.dart';

class AvatarShareProvider extends ChangeNotifier {
  final AvatarRepo _avatarRepo = AvatarRepo();

  List<UserModel> _recipients = [];
  List<UserModel> get recipients => _recipients;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
}
