import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/avaria.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'avaria.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE avarias (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dataAvaria TEXT,
        utilidade TEXT,
        descricao TEXT,
        valorAvaria INTEGER
      )
    ''');
  }

  Future<int> insertAvaria(Avaria avaria) async {
    final db = await database;
    return await db.insert('avarias', avaria.toMap());
  }

  Future<List<Avaria>> getAvarias() async {
    final db = await database;
    final maps = await db.query('avarias');
    return List.generate(maps.length, (i) => Avaria.fromMap(maps[i]));
  }

  Future<int> updateAvaria(Avaria avaria) async {
    final db = await database;
    return await db.update(
      'avarias',
      avaria.toMap(),
      where: 'id = ?',
      whereArgs: [avaria.id],
    );
  }

  Future<int> deleteAvaria(int id) async {
    final db = await database;
    return await db.delete('avarias', where: 'id = ?', whereArgs: [id]);
  }
}
