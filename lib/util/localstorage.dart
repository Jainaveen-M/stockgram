import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  // Database name
  static const String _databaseName = "stockgram.db";
  // Database version
  static const int _databaseVersion = 1;

  // Table name
  static const String table = 'market_order1';

  // Column names
  static const String columnId = 'id';
  static const String stockCode = 'code';
  static const String stockQty = 'qty';
  static const String stockPrice = 'price';
  static const String stockTotal = 'total';
  static const String orderType = 'orderType';

  // SQL to create the table
  static const String _createTableSQL = '''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $stockCode TEXT NOT NULL,
      $stockQty TEXT NOT NULL,
      $stockPrice TEXT NOT NULL,
      $stockTotal TEXT NOT NULL,
      $orderType TEXT NOT NULL
    )
  ''';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(_createTableSQL);
  }

  // CRUD operations

  // Insert
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(table, row);
  }

  // Query all rows
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await database;
    return await db.query(table);
  }

  // Query specific row
  Future<Map<String, dynamic>?> queryRow(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results =
        await db.query(table, where: '$columnId = ?', whereArgs: [id]);
    return results.isNotEmpty ? results.first : null;
  }

  // Update
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Delete
  Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
