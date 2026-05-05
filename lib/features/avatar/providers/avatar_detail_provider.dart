import 'package:avatar_flow/features/auth/models/user_model.dart';
import 'package:avatar_flow/features/avatar/models/avatar_model.dart';
import 'package:avatar_flow/features/avatar/repo/avatar_repo.dart';
import 'package:flutter/material.dart';

class AvatarDetailProvider extends ChangeNotifier {
  final AvatarRepo _repo = AvatarRepo();

  UserModel? _creator;
  UserModel? get creator => _creator;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Load creator info from the avatar model.
  /// Uses embedded data if available, otherwise fetches from DB.
  Future<void> loadCreator(AvatarModel avatar) async {
    // Already have creator name embedded in the model — use it directly
    if (avatar.creatorName != null) {
      _creator = UserModel(
        id: avatar.userId ?? '',
        email: '',
        name: avatar.creatorName,
        avatarUrl: avatar.creatorAvatarUrl,
      );
      notifyListeners();
      return;
    }

    // Need to fetch from DB
    final userId = avatar.userId;
    if (userId == null || userId.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    final result = await _repo.getUserById(userId);

    _creator = result;
    _isLoading = false;
    notifyListeners();
  }

  void reset() {
    _creator = null;
    _isLoading = false;
  }
}
