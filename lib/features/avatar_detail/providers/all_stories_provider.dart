import 'package:avatar_flow/features/avatar_detail/models/story_model.dart';
import 'package:flutter/material.dart';

class StoryProvider extends ChangeNotifier {
  final List<Story> _stories = [];
  List<Story> get stories => _stories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _page = 1;
  bool _hasMore = true;

  Future<void> fetchStories() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // simulate API

    // fake data
    List<Story> newStories = List.generate(10, (index) {
      return Story(
        title: "Story ${index + (_page * 10)}",
        author: "Author ${index + 1}",
        rating: "3.5",
        imageUrl: "https://picsum.photos/200/300?random=$index",
      );
    });

    if (newStories.isEmpty) {
      _hasMore = false;
    } else {
      _stories.addAll(newStories);
      _page++;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshStories() async {
    _page = 1;
    _hasMore = true;
    _stories.clear();
    await fetchStories();
  }
}
