import '../models/post.dart';

/// Stores the last successfully loaded posts, so the app can show them offline.
/// Given in the starter.
abstract class PostCache {
  Future<void> save(List<Post> posts);
  Future<List<Post>> load();
}

/// A cache that lives only in memory (used by the tests).
class MemoryPostCache implements PostCache {
  List<Post> _posts = [];

  @override
  Future<void> save(List<Post> posts) async => _posts = List.of(posts);

  @override
  Future<List<Post>> load() async => List.of(_posts);
}
