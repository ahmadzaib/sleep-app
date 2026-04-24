import 'package:avatar_flow/core/utils/toast_utils.dart';
import 'package:avatar_flow/features/avatar/models/avatar_model.dart';
import 'package:avatar_flow/features/avatar/repo/avatar_repo.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateAvatarProvider extends ChangeNotifier {
  final AvatarRepo _repo = AvatarRepo();

  int currentIndex = 0;
  String avatarName = "Lilian";
  String selectedGender = "Female";
  List<String> traits = ["Adventurous", "Charismatic"];
  String selectedVoice = "Voice 1";
  String prompt = "";
  bool _isCreating = false;

  bool get isCreating => _isCreating;

  void changeIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void updateName(String name) {
    avatarName = name;
    notifyListeners();
  }

  void updateGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void addTrait(String trait) {
    if (!traits.contains(trait)) {
      traits.add(trait);
      notifyListeners();
    }
  }

  void removeTrait(String trait) {
    traits.remove(trait);
    notifyListeners();
  }

  void updateVoice(String voice) {
    selectedVoice = voice;
    notifyListeners();
  }

  void updatePrompt(String newPrompt) {
    prompt = newPrompt;
    notifyListeners();
  }

  Future<void> createAvatar() async {
    if (avatarName.trim().isEmpty) {
      ToastUtils.error('Please enter a name for your avatar');
      return;
    }

    _isCreating = true;
    notifyListeners();

    try {
      final avatar = AvatarModel(
        name: avatarName.trim(),
        gender: selectedGender,
        traits: traits,
        avatarUrl: '', // null for now
        voiceUrl: null, // null for now
        userId: Supabase.instance.client.auth.currentUser!.id
            .toString(), // repo will set this
      );

      await _repo.createAvatar(avatar);
      ToastUtils.success('Avatar created successfully!');
    } catch (e) {
      ToastUtils.error('Failed to create avatar: $e');
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }
}
