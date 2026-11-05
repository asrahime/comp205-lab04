import 'package:flutter/foundation.dart';

import '../data/post_repository.dart';
import '../models/post.dart';

/// Part 4: the screen state.
class PostsViewModel extends ChangeNotifier {
  PostsViewModel(this._repository);

  // ignore: unused_field (you will use it in TODO 4.1)
  final PostRepository _repository;

  List<Post> posts = [];
  bool loading = false;
  bool offline = false;
  String? error;

  
  Future<void> load() async {
     loading = true;
  error = null;
  notifyListeners();

  try {
    final result = await _repository.loadPosts();

    posts = result.posts;
    offline = result.fromCache;
  } catch (e) {
    error = 'Could not load posts. Check your connection.';
  } finally {
    loading = false;
    notifyListeners();
  }

  }
}
