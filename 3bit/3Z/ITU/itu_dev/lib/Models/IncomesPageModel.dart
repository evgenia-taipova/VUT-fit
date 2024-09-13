/*
==========================================================================================================
File: IncomesPageModel.dart
Author: Dinara Garipova (xgarip00)

This Dart file defines an Income class representing individual income entries.
It also includes a model class (IncomesPageModel) that manages operations related to incomes,
such as loading data from the database, deleting incomes, and updating incomes.
The file also contains a database provider class (DBProvider) responsible for handling the SQLite database.
===========================================================================================================
*/
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Income class represents an individual income entry
class Income {
  int id;
  int walletId;
  String name;
  num amount;
  int color;
  IconData icon;
  DateTime creationDate;

  Income({
    required this.walletId,
    required this.name,
    required this.amount,
    required this.id,
    required this.color,
    required this.icon,
    required this.creationDate,
  });

  // Factory constructor to create an Income instance from database data
  factory Income.fromDb(Map<String, dynamic> dbData) {
    return Income(
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

// IncomesPageModel manages operations related to incomes
class IncomesPageModel {
  // Load income data from the database
  Future<List<Income>> loadDBData() async {
    DBProvider dbProvider = DBProvider("Income");
    Database database = await dbProvider.database;
    List<Map<String, dynamic>> result = await database.query('Income');
    return result.map((row) {
      return Income.fromDb(row);
    }).toList();
  }

  // Delete incomes associated with a specific wallet ID
  Future<void> deleteIncomesByWalletId(int walletId) async {
    List<Income> incomes = await loadDBData();
    incomes
        .where((income) => income.walletId == walletId)
        .forEach((income) => deleteIncomeFromDB(income.id));
  }

  // Get an income by its ID
  Future<Income> getIncomeById(int id) async {
    DBProvider dbProvider = DBProvider("Income");
    Database database = await dbProvider.database;
    List<Map<String, dynamic>> result = await database.query(
      'Income',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Income.fromDb(result.first);
    } else {
      throw Exception('Income not found');
    }
  }

  // Add an income to the database
  addIncomeToDb(int walletId, String name, num amount, int color, IconData icon, DateTime creationDate) async {
    DBProvider dbProvider = DBProvider("Income");
    await dbProvider.addIncomeToDb(walletId, name, amount, color, icon.codePoint, creationDate);
  }

  // Delete an income from the database
  deleteIncomeFromDB(id) async {
    DBProvider dbProvider = DBProvider("Income");
    dbProvider.deleteIncomeFromDB(id);
  }

  // Edit an income in the database
  editIncomeInDB(id, String newName, num newAmount, int newColor, IconData newIcon) async {
    DBProvider dbProvider = DBProvider("Income");
    dbProvider.editIncomeInDB(id, newName, newAmount, newColor, newIcon.codePoint);
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
            'CREATE TABLE Income (id INTEGER PRIMARY KEY, walletId INTEGER, name TEXT, amount NUMERIC, color INTEGER, icon INTEGER, creationDate TEXT)',
          );
        });
  }

  // Add an income to the database
  addIncomeToDb(walletId, name, amount, color, icon, creationDate) async {
    Database db = await database;
    int id = await _getNextId('Income');
    await db.rawInsert(
      "INSERT INTO Income (id, walletId, name, amount, color, icon, creationDate) VALUES (?, ?, ?, ?, ?, ?,?)",
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

  // Delete an income from the database by ID
  deleteIncomeFromDB(id) async {
    Database db = await database;
    await db.delete('Income', where: 'id = ?', whereArgs: [id]);
  }

  // Edit an income in the database
  editIncomeInDB(id, newName, newAmount, newColor, newIcon) async {
    Database db = await database;
    await db.update(
      'Income',
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
