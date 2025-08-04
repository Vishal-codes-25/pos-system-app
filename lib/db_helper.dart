import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'pos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            barcode TEXT UNIQUE,
            name TEXT,
            price REAL
          )
        ''');
      },
    );
  }

  static Future<Map<String, dynamic>?> getProduct(String barcode) async {
    final db = await database;
    final result = await db.query(
      'products',
      where: 'barcode = ?',
      whereArgs: [barcode],
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<void> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    await db.insert('products', product,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
