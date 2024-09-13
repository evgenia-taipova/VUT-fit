/*
=============================================================================================================
File: ExpensesPageModel.dart
// Author: Dinara Garipova (xgarip00)

// This Dart file defines an Expense class representing an individual expense.
// It also includes a model class (ExpensePageModel) that manages operations related to expenses,
// such as loading data from the database, deleting expenses, and updating expenses.
// The file also contains a database provider class (DBProvider) responsible for handling the SQLite database.
===============================================================================================================
*/
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Expense class represents an individual expense
class Expense {
  int id;
  int walletId;
  String name;
  num amount;
  int color;
  IconData icon;
  DateTime creationDate;

  Expense({
    required this.walletId,
    required this.name,
    required this.amount,
    required this.id,
    required this.color,
    required this.icon,
    required this.creationDate,
  });

  // Factory constructor to create an Expense instance from database data
  factory Expense.fromDb(Map<String, dynamic> dbData) {
    return Expense(
      id: dbData['id'] as int,
      walletId: dbData['walletId'] as int,
      name: dbData['name'] as String,
      amount: dbData['amount'] as num,
      color: dbData['color'] as int,
      icon: IconData(dbData['icon'] as int),
      creationDate: DateTime.parse(dbData['creationDate'] as String),
    );
  }
}

// ExpensePageModel manages operations related to expenses
class ExpensePageModel {
  // Load expense data from the database
  Future<List<Expense>> loadDBData() async {
    DBProvider dbProvider = DBProvider("EXPENSE");
    Database database = await dbProvider.database;
    List<Map<String, dynamic>> result = await database.query('EXPENSE');
    return result.map((row) {
      return Expense.fromDb(row);
    }).toList();
  }

  // Delete expenses associated with a specific wallet ID
  Future<void> deleteExpensesByWalletId(int walletId) async {
    List<Expense> expenses = await loadDBData();
    expenses
        .where((expense) => expense.walletId == walletId)
        .forEach((expense) => deleteExpenseFromDB(expense.id));
  }

  // Get an expense by its ID
  Future<Expense> getExpenseById(int id) async {
    DBProvider dbProvider = DBProvider("EXPENSE");
    Database database = await dbProvider.database;
    List<Map<String, dynamic>> result = await database.query(
      'EXPENSE',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Expense.fromDb(result.first);
    } else {
      throw Exception('Expense not found');
    }
  }

  // Add an expense to the database
  addExpenseToDb(int walletId, String name, num amount, int color, IconData icon, DateTime creationDate) async {
    DBProvider dbProvider = DBProvider("EXPENSE");
    await dbProvider.addExpenseToDb(walletId, name, amount, color, icon.codePoint, creationDate);
  }

  // Delete an expense from the database
  deleteExpenseFromDB(id) async {
    DBProvider dbProvider = DBProvider("EXPENSE");
    dbProvider.deleteExpenseFromDB(id);
  }

  // Edit an expense in the database
  editExpenseInDB(id, String newName, num newAmount, int newColor, IconData newIcon) async {
    DBProvider dbProvider = DBProvider("EXPENSE");
    dbProvider.editExpenseInDB(id, newName, newAmount, newColor, newIcon.codePoint);
  }
}

// DBProvider handles the SQLite database operations
class DBProvider {
  final String dbName;
  static final Map<String, DBProvider> _instances = {};

  DBProvider._internal(this.dbName);

  // Factory constructor to ensure a single instance per database name
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

  // Getter for the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialize the database
  _initDB() async {
    Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = join(documentsDirectory.path, "$dbName.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute(
            'CREATE TABLE EXPENSE (id INTEGER PRIMARY KEY, walletId INTEGER, name TEXT, amount NUMERIC, color INTEGER, icon INTEGER, creationDate TEXT)',
          );
        });
  }

  // Add an expense to the database
  addExpenseToDb(walletId, name, amount, color, icon, creationDate) async {
    Database db = await database;
    int id = await _getNextId('EXPENSE');
    await db.rawInsert(
      "INSERT INTO EXPENSE (id, walletId, name, amount, color, icon, creationDate) VALUES (?, ?, ?, ?, ?, ?,?)",
      [id, walletId, name, amount, color, icon, creationDate.toIso8601String()],
    );
  }

  // Get the next available ID for a table
  Future<int> _getNextId(String tableName) async {
    Database db = await database;
    List<Map<String, dynamic>> result =
    await db.rawQuery("SELECT MAX(id) + 1 as id FROM $tableName");
    int id = result.first['id'] ?? 1;
    return id;
  }

  // Delete an expense from the database by ID
  deleteExpenseFromDB(id) async {
    Database db = await database;
    await db.delete('EXPENSE', where: 'id = ?', whereArgs: [id]);
  }

  // Edit an expense in the database
  editExpenseInDB(id, newName, newAmount, newColor, newIcon) async {
    Database db = await database;
    await db.update(
      'EXPENSE',
      {
        'name': newName,
        'amount': newAmount,
        'color': newColor,
        'icon': newIcon
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
