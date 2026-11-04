/// Part 1: a post from https://jsonplaceholder.typicode.com/posts
///
/// One post in the API looks like:
///   {"userId": 1, "id": 1, "title": "…", "body": "…"}
class Post {
  const Post({required this.id, required this.userId, required this.title, required this.body});

  final int id;
  final int userId;
  final String title;
  final String body;

  /// Builds a Post from one JSON object. Throws a FormatException if a field is missing
  /// or has the wrong type.
  factory Post.fromJson(Map<String, dynamic> json) {
    // TODO(1.1): read the four fields. Tip: a map pattern (Week 2) checks shape and
    // types at once:  if (json case {'id': int id, ...}) { ... }
    throw UnimplementedError('Post.fromJson');
  }

  Map<String, dynamic> toJson() {
    // TODO(1.2): the opposite of fromJson (same keys).
    throw UnimplementedError('toJson');
  }
}
