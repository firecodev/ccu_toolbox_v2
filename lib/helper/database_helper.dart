import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {
  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(path.join(dbPath, 'courses.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE courses(id TEXT PRIMARY KEY, ecourse2Id INTEGER, name TEXT, teacher TEXT, type TEXT, credit TEXT, classroom TEXT, timeString TEXT)');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      await db.execute('DROP TABLE IF EXISTS courses');
      await db.execute(
          'CREATE TABLE courses(id TEXT PRIMARY KEY, ecourse2Id INTEGER, name TEXT, teacher TEXT, type TEXT, credit TEXT, classroom TEXT, timeString TEXT)');
    }, version: 3);
  }

  static Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await DatabaseHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DatabaseHelper.database();
    return db.query(table);
  }

  static Future<void> deleteAllData(String table) async {
    final db = await DatabaseHelper.database();
    await db.execute('DELETE FROM $table');
  }
}
