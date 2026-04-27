import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/utils/toast_utils.dart';
import 'package:avatar_flow/features/avatar/models/avatar_model.dart';
import 'package:avatar_flow/features/avatar/repo/avatar_repo.dart';
import 'package:flutter/material.dart';

class AvatarsProvider extends ChangeNotifier {
  final AvatarRepo _avatarRepo = AvatarRepo();

  List<AvatarModel> _avatars = [];
  List<AvatarModel> get avatars => _avatars;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  String? _error;
  String? get error => _error;

  /// Fetch all avatars for current user
  Future<void> fetchAvatars() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _avatars = await _avatarRepo.getMyAvatars();
      DebugPoint.log('Fetched ${_avatars.length} avatars');
    } catch (e) {
      _error = e.toString();
      DebugPoint.error('Failed to fetch avatars: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete an avatar
  Future<void> deleteAvatar(int avatarId) async {
    _isDeleting = true;
    notifyListeners();
    try {
      await _avatarRepo.deleteAvatar(avatarId);
      _avatars.removeWhere((avatar) => avatar.id == avatarId);
      notifyListeners();
      NavigationService.goNamed(AppRoutes.bottomNavbar);
    } catch (e) {
      DebugPoint.error('Failed to delete avatar: $e');
      ToastUtils.error('Failed to delete avatar');
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }
}
