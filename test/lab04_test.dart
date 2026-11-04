// Lab 4 - provided tests. Do NOT change this file; the TAs grade with the original.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab04_campus_feed/data/post_cache.dart';
import 'package:lab04_campus_feed/data/post_repository.dart';
import 'package:lab04_campus_feed/models/post.dart';
import 'package:lab04_campus_feed/screens/posts_screen.dart';
import 'package:lab04_campus_feed/view_models/posts_view_model.dart';
import 'package:provider/provider.dart';

const twoPosts = [
  {'userId': 1, 'id': 1, 'title': 'Welcome week', 'body': 'Events on campus'},
  {'userId': 2, 'id': 2, 'title': 'Library hours', 'body': 'Open until 22:00'},
];

MockClient okClient() => MockClient((request) async => http.Response(jsonEncode(twoPosts), 200));
MockClient statusClient(int code) => MockClient((request) async => http.Response('error', code));
MockClient throwingClient() => MockClient((request) async => throw http.ClientException('no network'));

void main() {
  group('Part 1 - Post.fromJson', () {
    test('reads all fields', () {
      final p = Post.fromJson(twoPosts.first);
      expect(p.id, 1);
      expect(p.userId, 1);
      expect(p.title, 'Welcome week');
      expect(p.body, 'Events on campus');
    });

    test('toJson gives back the same map', () {
      expect(Post.fromJson(twoPosts.last).toJson(), twoPosts.last);
    });

    test('a missing field throws a FormatException', () {
      expect(() => Post.fromJson({'id': 1, 'title': 'x'}), throwsFormatException);
    });
  });

  group('Part 2 - fetchFromNetwork', () {
    test('GETs the posts URL and parses the list', () async {
      Uri? requested;
      final client = MockClient((request) async {
        requested = request.url;
        return http.Response(jsonEncode(twoPosts), 200);
      });
      final repo = PostRepository(client: client, cache: MemoryPostCache());
      final posts = await repo.fetchFromNetwork();
      expect(posts.map((p) => p.title), ['Welcome week', 'Library hours']);
      expect(requested, PostRepository.postsUri);
    });

    test('a non-200 status throws ApiException with the code', () async {
      final repo = PostRepository(client: statusClient(503), cache: MemoryPostCache());
      await expectLater(
        repo.fetchFromNetwork(),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 503)),
      );
    });
  });

  group('Part 3 - loadPosts with cache', () {
    test('success: posts from the network, saved to the cache', () async {
      final cache = MemoryPostCache();
      final repo = PostRepository(client: okClient(), cache: cache);
      final result = await repo.loadPosts();
      expect(result.fromCache, isFalse);
      expect(result.posts, hasLength(2));
      expect(await cache.load(), hasLength(2));
    });

    test('network error: the cached posts are returned, fromCache is true', () async {
      final cache = MemoryPostCache();
      await cache.save([Post.fromJson(twoPosts.first)]);
      final repo = PostRepository(client: throwingClient(), cache: cache);
      final result = await repo.loadPosts();
      expect(result.fromCache, isTrue);
      expect(result.posts.single.title, 'Welcome week');
    });

    test('server error with a cache also falls back', () async {
      final cache = MemoryPostCache();
      await cache.save([Post.fromJson(twoPosts.last)]);
      final repo = PostRepository(client: statusClient(500), cache: cache);
      expect((await repo.loadPosts()).fromCache, isTrue);
    });

    test('error and an empty cache: the error is thrown', () async {
      final repo = PostRepository(client: throwingClient(), cache: MemoryPostCache());
      await expectLater(repo.loadPosts(), throwsA(isA<http.ClientException>()));
    });
  });

  group('Part 4 - ViewModel and screen', () {
    Future<void> pumpScreen(WidgetTester tester, PostsViewModel vm) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ChangeNotifierProvider.value(
        value: vm,
        child: const MaterialApp(home: PostsScreen()),
      ));
    }

    test('load sets posts and clears loading', () async {
      final vm = PostsViewModel(PostRepository(client: okClient(), cache: MemoryPostCache()));
      await vm.load();
      expect(vm.posts, hasLength(2));
      expect(vm.loading, isFalse);
      expect(vm.offline, isFalse);
      expect(vm.error, isNull);
    });

    testWidgets('shows the posts in a list', (tester) async {
      final vm = PostsViewModel(PostRepository(client: okClient(), cache: MemoryPostCache()));
      await vm.load();
      await pumpScreen(tester, vm);
      expect(find.text('Campus Feed'), findsOneWidget);
      expect(find.text('Library hours'), findsOneWidget);
    });

    testWidgets('offline: shows the banner text', (tester) async {
      final cache = MemoryPostCache();
      await cache.save([Post.fromJson(twoPosts.first)]);
      final vm = PostsViewModel(PostRepository(client: throwingClient(), cache: cache));
      await vm.load();
      await pumpScreen(tester, vm);
      expect(find.text('Offline - showing saved posts'), findsOneWidget);
      expect(find.text('Welcome week'), findsOneWidget);
    });

    testWidgets('error: shows the message and a Try again button', (tester) async {
      final vm = PostsViewModel(PostRepository(client: throwingClient(), cache: MemoryPostCache()));
      await vm.load();
      await pumpScreen(tester, vm);
      expect(find.text('Could not load posts. Check your connection.'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });
  });
}
