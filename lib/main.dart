import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'data/post_repository.dart';
import 'data/sqlite_post_cache.dart';
import 'screens/posts_screen.dart';
import 'view_models/posts_view_model.dart';

/// Given in the starter.
void main() {
  final repository = PostRepository(client: http.Client(), cache: SqlitePostCache());
  runApp(
    ChangeNotifierProvider(
      create: (_) => PostsViewModel(repository)..load(),
      child: MaterialApp(
        title: 'Campus Feed',
        theme: ThemeData(colorSchemeSeed: Colors.green),
        home: const PostsScreen(),
      ),
    ),
  );
}
