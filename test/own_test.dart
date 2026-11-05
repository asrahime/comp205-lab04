import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab04_campus_feed/data/post_repository.dart';
import 'package:lab04_campus_feed/data/post_cache.dart';
import 'package:lab04_campus_feed/models/post.dart';

void main() {
  test('posts URL uses HTTPS and jsonplaceholder', () {
    expect(PostRepository.postsUri.scheme, 'https');
    expect(PostRepository.postsUri.host, 'jsonplaceholder.typicode.com');
  });

  test('Post.fromJson throws error when id has wrong type', () {
    expect(
      () => Post.fromJson({
        'id': '1',
        'userId': 1,
        'title': 'Test',
        'body': 'Test body',
      }),
      throwsFormatException,
    );
  });

  test('fetchFromNetwork throws ApiException for 404 response', () async {
    final client = MockClient((request) async {
      return http.Response('Not Found', 404);
    });

    final repository = PostRepository(
      client: client,
      cache: MemoryPostCache(),
    );

    await expectLater(
      repository.fetchFromNetwork(),
      throwsA(
        isA<ApiException>().having(
          (error) => error.statusCode,
          'statusCode',
          404,
        ),
      ),
    );

    client.close();
  });
}