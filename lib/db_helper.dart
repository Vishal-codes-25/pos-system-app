import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;
  static const int _dbVersion = 2;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'pos.db');

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create table (fresh install)
  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcode TEXT UNIQUE,
        name TEXT,
        brand TEXT,
        price REAL
      )
    ''');
  }

  /// Handle DB upgrades (existing users)
  static Future<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE products ADD COLUMN brand TEXT');
    }
  }

  /// Get product by barcode
  static Future<Map<String, dynamic>?> getProduct(String barcode) async {
    final db = await database;
    final result = await db.query(
      'products',
      where: 'barcode = ?',
      whereArgs: [barcode],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Insert or update product
  static Future<void> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    await db.insert(
      'products',
      {
        'barcode': product['barcode'],
        'name': product['name'],
        'brand': product['brand'],
        'price': product['price'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
