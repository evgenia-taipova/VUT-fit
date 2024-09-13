/*
================================================================================
File: SpecificWalletPageModel.dart
Author: Garipova Dinara (xgarip00)

This Dart file defines a singleton database provider class (DBProvider)
for handling SQLite databases using the sqflite package.
It includes a factory constructor to ensure a single instance per database name.
================================================================================
*/
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider {
  // Name of the database
  final String dbName;

  // Map to store instances of DBProvider for each database name
  static final Map<String, DBProvider> _instances = {};

  // Private constructor to prevent direct instantiation
  DBProvider._internal(this.dbName);

  // Factory constructor to ensure a single instance per database name
  factory DBProvider(String dbName) {
    if (_instances.containsKey(dbName)) {
      // Return existing instance if available
      return _instances[dbName]!;
    } else {
      // Create a new instance, store it in the map, and return it
      final instance = DBProvider._internal(dbName);
      _instances[dbName] = instance;
      return instance;
    }
  }

  // Database instance variable
  Database? _database;
}
