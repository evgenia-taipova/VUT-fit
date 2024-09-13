/*
===========================================================================
  Author: xkulin01
  Description: Model for debts
===========================================================================
*/

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Define a Debt class representing the structure of debt data
class Debt {
  int id;
  String name;
  String date;
  String amount;

  // Constructor for creating a Debt object
  Debt({required this.id, required this.name, required this.date, required this.amount});

  // Factory method to create a Debt object from database data
  factory Debt.fromDb(Map<String, dynamic> dbData) {
    return Debt(
      id: dbData['id'] as int,
      name: dbData['name'] as String,
      date: dbData['date'] as String,
      amount: dbData['amount'] as String,
    );
  }
}

// Define DebtPageModel class for managing data interaction with the database
class DebtPageModel {
  // Method to load debt data from the database
  Future<List<Debt>> loadDBData() async {
    DBProvider dbProvider = DBProvider("DEBTS");
    Database database = await dbProvider.database;
    List<Map<String, dynamic>> result = await database.query('DEBTS');
    return result.map((row) {
      return Debt.fromDb(row);
    }).toList();
  }

  // Method to add debt data to the database
  addDebtToDb(name, date, amount) async {
    DBProvider dbProvider = DBProvider("DEBTS");
    dbProvider.addDebtToDb(name, date, amount);
  }

  // Method to delete debt data from the database
  dellDebtFromDB(id) async {
    DBProvider dbProvider = DBProvider("DEBTS");
    dbProvider.dellDebtFromDB(id);
  }

  // Method to edit debt data in the database
  editDebtInDB(id, newName, newAmount, newDate) async {
    DBProvider dbProvider = DBProvider("DEBTS");
    dbProvider.editDebtInDB(id, newName, newAmount, newDate);
  }
}

// Define DBProvider class for managing the database
class DBProvider {
  final String dbName;
  static final Map<String, DBProvider> _instances = {};

  // Private constructor for creating a singleton instance
  DBProvider._internal(this.dbName);

  // Factory method to create a singleton instance of DBProvider
  factory DBProvider(String dbName) {
    if (_instances.containsKey(dbName)) {
      return _instances[dbName]!;
    } else {
      final instance = DBProvider._internal(dbName);
      _instances[dbName] = instance;
      return instance;
    }
  }

  Database? _database;

  // Getter for accessing the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialize the database
  _initDB() async {
    Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = join(documentsDirectory.path, "$dbName.db");
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE DEBTS (id INTEGER PRIMARY KEY, name TEXT, date TEXT, amount TEXT)');
    });
  }

  // Method to add debt data to the database
  addDebtToDb(name, date, amount) async {
    Database db = await database;
    int id = await _getNextId();
    await db.rawInsert(
      "INSERT INTO DEBTS (id, name, date, amount) VALUES (?, ?, ?, ?)",
      [id, name, date, amount],
    );
  }

  // Get the next available ID for a new record in the database
  Future<int> _getNextId() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery("SELECT MAX(id) + 1 as id FROM DEBTS");
    int id = result.first['id'] ?? 1;
    return id;
  }

  // Method to delete debt data from the database
  dellDebtFromDB(id) async {
    Database db = await database;
    await db.delete('DEBTS', where: 'id = ?', whereArgs: [id]);
  }

  // Method to edit debt data in the database
  editDebtInDB(id, newName, newAmount, newDate) async {
    Database db = await database;
    await db.update(
      'DEBTS',
      {
        'name': newName,
        'amount': newAmount,
        'date': newDate,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}