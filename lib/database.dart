// All local database (sqflite) code lives in this one file.
// Task files only call these functions - they never touch SQL directly.

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class database_helper {
  static late Database db;

  // Call this once in main() before runApp()
  static Future<void> init() async {
    db = await openDatabase(
      join(await getDatabasesPath(), 'app.db'),
      version: 1,
      onCreate: (database, version) async {
        await database.execute('CREATE TABLE wishlist(name TEXT)');
        await database.execute(
          'CREATE TABLE settings(key TEXT PRIMARY KEY, value INTEGER)',
        );
        await database.execute('CREATE TABLE news(title TEXT)');
      },
    );
  }

  // ---------- Task 2: Wishlist ----------
  static Future<List<String>> getWishlist() async {
    final rows = await db.query('wishlist');
    return rows.map((row) => row['name'] as String).toList();
  }

  static Future<void> addToWishlist(String name) async {
    await db.insert('wishlist', {'name': name});
  }

  static Future<void> removeFromWishlist(String name) async {
    await db.delete('wishlist', where: 'name = ?', whereArgs: [name]);
  }

  // ---------- Task 3: Dark mode setting ----------
  static Future<bool> getDarkMode() async {
    final rows = await db.query(
      'settings',
      where: 'key = ?',
      whereArgs: ['dark'],
    );
    if (rows.isEmpty) return false; // default = light theme
    return rows.first['value'] == 1;
  }

  static Future<void> saveDarkMode(bool value) async {
    await db.insert(
      'settings',
      {'key': 'dark', 'value': value ? 1 : 0},
      conflictAlgorithm: ConflictAlgorithm.replace, // overwrite old value
    );
  }

  // ---------- Task 4: News cache ----------
  static Future<List<String>> getNews() async {
    final rows = await db.query('news');
    return rows.map((row) => row['title'] as String).toList();
  }

  static Future<void> saveNews(List<String> headlines) async {
    await db.delete('news'); // remove old headlines
    for (var title in headlines) {
      await db.insert('news', {'title': title});
    }
  }
}
