import 'package:http/http.dart' as http;

import '../models/post.dart';
import 'post_cache.dart';

/// Thrown when the server answers with an error status code. Given.
class ApiException implements Exception {
  ApiException(this.statusCode);
  final int statusCode;
  @override
  String toString() => 'ApiException($statusCode)';
}

/// The result of loading posts: the posts, and whether they came from the cache. Given.
class PostsResult {
  const PostsResult(this.posts, {required this.fromCache});
  final List<Post> posts;
  final bool fromCache;
}

/// Parts 2 and 3: loads posts from the web API, with the cache as a fallback.
class PostRepository {
  PostRepository({required this.client, required this.cache});

  static final Uri postsUri = Uri.parse('https://jsonplaceholder.typicode.com/posts?_limit=20');

  final http.Client client;
  final PostCache cache;

  /// Part 2: GET postsUri with client.get(postsUri).timeout(const Duration(seconds: 10))
  /// (TimeoutException and .timeout come from 'dart:async').
  /// Status 200 -> decode the body (jsonDecode, from 'dart:convert') into a list of Post.
  /// Any other status -> throw ApiException(statusCode).
  Future<List<Post>> fetchFromNetwork() async {
    // TODO(2)
    throw UnimplementedError('fetchFromNetwork');
  }

  /// Part 3: network first. On success, save to the cache and return
  /// PostsResult(posts, fromCache: false). On ANY failure, return the cached posts
  /// with fromCache: true - or rethrow the error if the cache is empty.
  Future<PostsResult> loadPosts() async {
    // TODO(3)
    throw UnimplementedError('loadPosts');
  }
}
