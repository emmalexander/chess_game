import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'chess_game.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE moves(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        startRow INTEGER,
        startCol INTEGER,
        endRow INTEGER,
        endCol INTEGER,
        pieceType TEXT,
        pieceIsWhite INTEGER,
        capturedPieceType TEXT,
        capturedPieceIsWhite INTEGER,
        isWhiteMove INTEGER
      )
    ''');
  }

  Future<void> insertMove(Map<String, dynamic> move) async {
    Database db = await database;
    await db.insert('moves', move);
  }

  Future<List<Map<String, dynamic>>> getMoves() async {
    Database db = await database;
    return await db.query('moves', orderBy: 'id DESC');
  }

  Future<void> deleteLastMove() async {
    Database db = await database;
    var lastId = Sqflite.firstIntValue(
      await db.rawQuery('SELECT MAX(id) FROM moves'),
    );
    if (lastId != null) {
      await db.delete('moves', where: 'id = ?', whereArgs: [lastId]);
    }
  }

  Future<void> clearMoves() async {
    Database db = await database;
    await db.delete('moves');
  }
}
