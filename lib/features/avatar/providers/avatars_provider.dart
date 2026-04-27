import 'package:avatar_flow/core/debug/debug_point.dart';
import 'package:avatar_flow/features/avatar/models/avatar_model.dart';
import 'package:avatar_flow/features/avatar/repo/avatar_repo.dart';
import 'package:flutter/material.dart';

class AvatarsProvider extends ChangeNotifier {
  final AvatarRepo _avatarRepo = AvatarRepo();

  List<AvatarModel> _avatars = [];
  List<AvatarModel> get avatars => _avatars;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
}
