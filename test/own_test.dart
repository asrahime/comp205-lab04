// Lab 4 - YOUR tests (at least 2 more). Yellow zone: if an AI assistant wrote code
// for you, these tests are how you check it.
//
// Ideas:
//  - Post.fromJson with a wrong type (e.g. 'id': '1' as a String) throws
//  - fetchFromNetwork throws ApiException(404) for a 404 response (use MockClient)
//  - loadPosts saves exactly the posts it received
import 'package:flutter_test/flutter_test.dart';
import 'package:lab04_campus_feed/data/post_repository.dart';

void main() {
  // Example (given): the repository talks to the public test API over HTTPS.
  test('posts URL uses HTTPS and jsonplaceholder', () {
    expect(PostRepository.postsUri.scheme, 'https');
    expect(PostRepository.postsUri.host, 'jsonplaceholder.typicode.com');
  });

  // TODO(6): write at least 2 tests of your own below.
}
