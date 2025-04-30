import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper{
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();
  static Database? _database;
  Future<Database> get  database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'Enexpense.db');
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
    );
  }
  Future<void> _createDB(Database db, int version) async {
    const tables = [
      '''
    CREATE TABLE users (
      userId INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      createdAt TIMESTAMP NOT NULL,
      updatedAt TIMESTAMP NOT NULL
    )
    ''',
    ];

    for (var table in tables) {
      await db.execute(table);
    }

    print('Subscription data inserted');

    await insertDummyUserData(db);
    print('User data inserted');
  }

  Future<void> insertDummyUserData(Database db) async {
    final dummyUsers = [
      {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Jane Smith',
        'email': 'jane.smith@example.com',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    ];

    for (var user in dummyUsers) {
      await db.insert(
        'users',
        user,
        conflictAlgorithm:
        ConflictAlgorithm.replace, // Prevent duplicate entries
      );
    }

    print('Dummy user data inserted successfully.');
  }
}