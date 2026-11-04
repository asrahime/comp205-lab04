import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/post.dart';
import 'post_cache.dart';

/// Part 5: the real cache on the phone, in an SQLite table.
///
///   posts(id INTEGER PRIMARY KEY, user_id INTEGER, title TEXT, body TEXT)
///
/// The tests use MemoryPostCache; this class is checked on the emulator
/// (load once online, then turn on airplane mode and restart the app).
class SqlitePostCache implements PostCache {
  Database? _db;

  /// Given: opens (and on first use creates) the database.
  Future<Database> _open() async {
    return _db ??= await openDatabase(
      join(await getDatabasesPath(), 'campus_feed.db'),
      version: 1,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE posts(id INTEGER PRIMARY KEY, user_id INTEGER, title TEXT, body TEXT)',
      ),
    );
  }

  @override
  Future<void> save(List<Post> posts) async {
    // TODO(5.1): in one transaction: delete all rows, then insert every post
    // (columns id, user_id, title, body).
    await _open();
  }

  @override
  Future<List<Post>> load() async {
    // TODO(5.2): query all rows ordered by id and turn each row back into a Post.
    await _open();
    return [];
  }
}
