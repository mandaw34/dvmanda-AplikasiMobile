import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expense_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // tabel users untuk multi-user
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE,
        password TEXT
      )
    ''');

    // tabel transactions 
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userEmail TEXT,
        title TEXT,
        amount TEXT,
        type TEXT,
        date TEXT
      )
    ''');
  }

  Future<double> calculateBalance(String userEmail) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'userEmail = ?',
      whereArgs: [userEmail],
    );

    double totalBalance = 0.0;

    for (var row in result) {
      String rawAmount = row['amount'].toString();
      String cleanAmount = rawAmount.replaceAll('.', '').replaceAll(',', '.');
      
      double amount = double.tryParse(cleanAmount) ?? 0.0;
      String type = row['type'].toString().trim().toLowerCase();

      if (type == 'pemasukan' || type == 'income') {
        totalBalance += amount;
      } else if (type == 'pengeluaran' || type == 'expense') {
        totalBalance -= amount;
      }
    }

    return totalBalance;
  }

  Future<List<Map<String, dynamic>>> getTransactions(String userEmail) async {
    final db = await instance.database;
    return await db.query(
      'transactions',
      where: 'userEmail = ?',
      whereArgs: [userEmail],
      orderBy: 'id DESC',
    );
  }

  // fungsi tambah transaksi
  Future<int> insertTransaction(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('transactions', row);
  }

  // fungsi register user
  Future<int> registerUser(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert('users', row);
  }

  // fungsi login user
  Future<bool> loginUser(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }
}