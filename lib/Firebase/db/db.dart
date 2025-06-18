import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../Models/ExpenseModel.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'econnect.db');
    return await openDatabase(
      path,
      version: 25,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const tables = [
      '''
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  amount REAL NOT NULL,
  description TEXT NOT NULL,
  firebaseUid TEXT NOT NULL,
  date TIMESTAMP NOT NULL
);

    ''',
    ];

    for (var table in tables) {
      await db.execute(table);
    }

    print('Subscription data inserted');

    print('User data inserted');
  }

  Future<void> insertDummyUserData1(Database db) async {
    final dummyUsers = [
      ExpenseModel(
          amount: 200.0,
          description: 'ss',
          firebaseUid: '23',
          name: 'sivabala',
          date: DateTime.now()),
      ExpenseModel(
          amount: 100.0,
          description: 'ssssss',
          firebaseUid: '24',
          name: 'balalsiva',
          date: DateTime.now()),
    ];

    for (var user in dummyUsers) {
      await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm:
            ConflictAlgorithm.replace, // Prevent duplicate entries
      );
    }

    print('Dummy user data inserted successfully.');
  }
}
