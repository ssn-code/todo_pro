import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppDatabase {
  AppDatabase._(); static final instance = AppDatabase._(); Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) { sqfliteFfiInit(); databaseFactory = databaseFactoryFfi; }
    _database = await openDatabase('todo_pro.db', version: 1, onCreate: (db, version) async => db.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT NOT NULL,description TEXT,is_completed INTEGER NOT NULL DEFAULT 0,priority TEXT NOT NULL,due_date INTEGER,created_at INTEGER NOT NULL,updated_at INTEGER NOT NULL,completed_at INTEGER,project_id INTEGER)'));
    return _database!;
  }
}
