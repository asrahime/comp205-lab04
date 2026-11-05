class Post {
  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  final int id;
  final int userId;
  final String title;
  final String body;

  factory Post.fromJson(Map<String, dynamic> json) {
    if (json case {
      'id': int id,
      'userId': int userId,
      'title': String title,
      'body': String body,
    }) {
      return Post(
        id: id,
        userId: userId,
        title: title,
        body: body,
      );
    }

    throw FormatException('Invalid post data');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}