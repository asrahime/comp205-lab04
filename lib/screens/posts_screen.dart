import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_models/posts_view_model.dart';

/// Part 4: loading, error, offline banner and the list.
class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PostsViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Campus Feed')),
      // TODO(4.2): show
      //  - a CircularProgressIndicator while loading (and no posts yet)
      //  - on error: the error text and a FilledButton 'Try again' that calls load()
      //  - otherwise a Column: if offline, a banner with the text
      //    'Offline - showing saved posts', then an Expanded list of ListTiles
      //    (title, and the body as subtitle with maxLines: 2)
      //  - bonus: RefreshIndicator for pull-to-refresh
      body: Center(child: Text('${vm.posts.length} posts - TODO')),
    );
  }
}
