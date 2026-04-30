import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/core/router/navigation_service.dart';
import 'package:avatar_flow/core/router/routes.dart';
import 'package:avatar_flow/core/utils/toast_utils.dart';
import 'package:avatar_flow/features/avatar/models/avatar_model.dart';
import 'package:avatar_flow/features/avatar/models/shared_avatar_model.dart';
import 'package:avatar_flow/features/avatar/repo/avatar_repo.dart';
import 'package:flutter/material.dart';

class AvatarsProvider extends ChangeNotifier {
  final AvatarRepo _avatarRepo = AvatarRepo();

  // ── My Avatars ───────────────────────────────────────────────────────────
  List<AvatarModel> _avatars = [];
  List<AvatarModel> get avatars => _avatars;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;

  String? _error;
  String? get error => _error;

  // ── Shared Avatars ────────────────────────────────────────────────────────
  List<SharedAvatarModel> _sharedAvatars = [];
  List<SharedAvatarModel> get sharedAvatars => _sharedAvatars;

  bool _isLoadingShared = false;
  bool get isLoadingShared => _isLoadingShared;

  bool _isRemoving = false;
  bool get isRemoving => _isRemoving;

  String? _sharedError;
  String? get sharedError => _sharedError;

  // ── My Avatars Methods ────────────────────────────────────────────────────

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

  // ── Shared Avatars Methods ────────────────────────────────────────────────

  /// Fetch all avatars shared with the current user
  Future<void> fetchSharedAvatars() async {
    _isLoadingShared = true;
    _sharedError = null;
    notifyListeners();

    try {
      _sharedAvatars = await _avatarRepo.getSharedAvatars();
      DebugPoint.log('Fetched ${_sharedAvatars.length} shared avatars');
    } catch (e) {
      _sharedError = e.toString();
      DebugPoint.error('Failed to fetch shared avatars: $e');
    } finally {
      _isLoadingShared = false;
      notifyListeners();
    }
  }

  /// Remove a shared avatar (un-share from current user's list)
  Future<void> removeSharedAvatar(int sharedId) async {
    _isRemoving = true;
    notifyListeners();
    try {
      await _avatarRepo.removeSharedAvatar(sharedId);
      _sharedAvatars.removeWhere((s) => s.id == sharedId);
      notifyListeners();
      DebugPoint.log('Removed shared avatar $sharedId from local list');
    } catch (e) {
      DebugPoint.error('Failed to remove shared avatar: $e');
      ToastUtils.error('Failed to remove avatar');
    } finally {
      _isRemoving = false;
      notifyListeners();
    }
  }
}
