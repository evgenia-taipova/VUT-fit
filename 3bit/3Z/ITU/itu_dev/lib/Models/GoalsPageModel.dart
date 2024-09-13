// File: GoalsPageModel.dart
// Author: Taipova Evgeniya (xtaipo00)
// Description: This file contains the implementation of the GoalsPageModel class,
// which handles the interaction with the goals database.

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Goal{
  int id;
  String name;
  String goalAmount;
  String amount;
  String date;

  Goal({
    required this.id,
    required this.name,
    required this.goalAmount,
    required this.amount,
    required this.date,
  });

  // Factory method to create a Goal object from database data.
  factory Goal.fromDb(Map<String, dynamic> dbData){
    return Goal(
      id: dbData['id'] as int,
      name: dbData['name'] as String,
      goalAmount: dbData['goalAmount'] as String,
      amount: dbData['amount'] as String,
      date: dbData['date'] as String,
    );
  }
}
// The GoalsPageModel class handles interactions with the goals database.
class GoalsPageModel{
  // Load data from the database
  Future<List<Goal>> loadDBData() async {
    // Create a DBProvider instance for 'GOALS' database.
    DBProvider dbProvider = DBProvider("GOALS");
    Database database = await dbProvider.database;
    List<Map<String, dynamic>> result = await database.query('GOALS');
    return result.map((row) {
      return Goal.fromDb(row);
    }).toList();
  }

  // Add a goal to the database
  addGoalToDb(name,  goalAmount, amount,date) async{
    DBProvider dbProvider = DBProvider("GOALS");
    dbProvider.addGoalToDb(name, goalAmount, amount, date);
  }

  // Delete a goal from the database
  dellGoalFromDB(id) async{
    DBProvider dbProvider = DBProvider("GOALS");
    dbProvider.dellGoalFromDB(id);
  }

  // Edit a goal in the database
  editGoalInDB(id, newName,newGoalAmount, newAmount, newDate) async{
    DBProvider dbProvider = DBProvider("GOALS");
    dbProvider.editGoalInDB(id, newName, newGoalAmount, newAmount, newDate);
  }

}

// The DBProvider class manages database operations.
class DBProvider {
  final String dbName;
  static final Map<String, DBProvider> _instances = {};

  DBProvider._internal(this.dbName);

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

  // Get the database instance.
  Future<Database> get database async {
    /*Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = join(documentsDirectory.path, "$dbName.db");
    await deleteDatabase(path);*/
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Initialize the database.
  _initDB() async {
    Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = join(documentsDirectory.path, "$dbName.db");
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE GOALS (id INTEGER PRIMARY KEY, name TEXT ,' 'goalAmount TEXT, ' 'amount TEXT,  ' 'date TEXT)');
    });
  }

  // Add a new goal to the database.
  addGoalToDb(name,goalAmount, amount,date ) async{
    Database db = await database;
    int id = await _getNextIdGoal();
    await db.rawInsert(
      "INSERT INTO GOALS (id, name, goalAmount, amount, date) VALUES (?, ?, ?, ?, ?)",
      [id, name, goalAmount, amount, date],
    );
  }

  // Get the next available ID for a new goal.
  Future<int> _getNextIdGoal() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery("SELECT MAX(id) + 1 as id FROM GOALS");
    int id = result.first['id'] ?? 1;
    return id;
  }

  // Delete a goal from the database based on its ID.
  dellGoalFromDB(id) async{
    Database db = await database;
    await db.delete('GOALS', where: 'id = ?', whereArgs: [id]);
  }

  // Edit a goal in the database based on its ID.
  editGoalInDB(id, newName, newGoalAmount, newAmount, newDate) async {
    Database db = await database;
    await db.update(
      'GOALS',
      {
        'name': newName,
        'goalAmount':newGoalAmount,
        'amount': newAmount,
        'date': newDate,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}
