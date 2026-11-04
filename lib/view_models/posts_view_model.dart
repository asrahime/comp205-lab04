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

  /// TODO(4.1): set loading (notify), call _repository.loadPosts(), store posts and
  /// offline (= result.fromCache). On an error set
  ///   error = 'Could not load posts. Check your connection.'
  /// Always end with loading = false and notifyListeners().
  Future<void> load() async {}
}
