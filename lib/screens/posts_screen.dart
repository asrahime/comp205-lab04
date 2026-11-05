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
    body: Builder(
  builder: (context) {
    if (vm.loading && vm.posts.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (vm.error != null && vm.posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(vm.error!),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => vm.load(),
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (vm.offline)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.orange,
            child: const Text(
              'Offline - showing saved posts',
              textAlign: TextAlign.center,
            ),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: vm.load,
            child: ListView.builder(
              itemCount: vm.posts.length,
              itemBuilder: (context, index) {
                final post = vm.posts[index];

                return ListTile(
                  title: Text(post.title),
                  subtitle: Text(
                    post.body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  },
),
    );
  }
}
