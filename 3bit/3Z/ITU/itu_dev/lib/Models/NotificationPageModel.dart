/*
===========================================================================
  Author: xkulin01
  Description: Model for notifications
===========================================================================
*/

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Define a Notification class representing the structure of notification data
class Notification {
  int id;
  String title;
  String body;

  // Constructor for creating a Notification object
  Notification({required this.id, required this.title, required this.body});

  // Factory method to create a Notification object from database data
  factory Notification.fromDb(Map<String, dynamic> dbData) {
    return Notification(
      id: dbData['id'] as int,
      title: dbData['title'] as String,
      body: dbData['body'] as String,
    );
  }
}

// Define NotificationPageModel class for managing data interaction with the database
class NotificationPageModel {
  // Method to load notification data from the database
  Future<List<Notification>> loadDBData() async {
    DBProvider dbProvider = DBProvider("NOTIFICATIONS");
    Database database = await dbProvider.database;
    List<Map<String, dynamic>> result = await database.query('NOTIFICATIONS');
    return result.map((row) {
      return Notification.fromDb(row);
    }).toList();
  }

  // Method to add notification data to the database
  addNotificationToDb(id, title, body) async {
    DBProvider dbProvider = DBProvider("NOTIFICATIONS");
    dbProvider.addNotificationToDb(id, title, body);
  }

  // Method to delete notification data from the database
  dellNotificationFromDB(id) async {
    DBProvider dbProvider = DBProvider("NOTIFICATIONS");
    dbProvider.dellNotificationFromDB(id);
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
      await db.execute('CREATE TABLE NOTIFICATIONS (id INTEGER PRIMARY KEY, title TEXT, body TEXT)');
    });
  }

  // Method to add notification data to the database
  addNotificationToDb(id, title, body) async {
    Database db = await database;
    await db.rawInsert(
      "INSERT INTO NOTIFICATIONS (id, title, body) VALUES (?, ?, ?)",
      [id, title, body],
    );
  }

  // Method to delete notification data from the database
  dellNotificationFromDB(id) async {
    Database db = await database;
    await db.delete('NOTIFICATIONS', where: 'id = ?', whereArgs: [id]);
  }
}