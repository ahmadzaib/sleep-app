import 'package:flutter/material.dart';

class AvatarProvider extends ChangeNotifier {
  int currentIndex = 0;
  String avatarName = "Lilian";
  String selectedGender = "Female";
  List<String> traits = ["Adventurous", "Charismatic"];
  String selectedVoice = "Voice 1";
  String prompt = "";

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
}
