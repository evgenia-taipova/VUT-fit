/*
===========================================================================
  Author: xkulin01
  Description: Model for tips
===========================================================================
*/

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Model class representing a financial tip
class Tip {
  String title;    // Title of the tip
  String time;     // Time associated with the tip
  String text;     // Content or description of the tip
  String category; // Category to which the tip belongs

  // Constructor for creating a Tip instance
  Tip({required this.title, required this.time, required this.text, required this.category});

  // Factory method to create a Tip instance from database data
  factory Tip.fromDb(Map<String, dynamic> dbData) {
    return Tip(
      title: dbData['title'] as String,
      time: dbData['time'] as String,
      text: dbData['text'] as String,
      category: dbData['category'] as String,
    );
  }
}

// Model class for managing tips data on the Tips page
class TipsPageModel {
  // Load tips data from the database
  Future<List<Tip>> loadDBData() async {
    DBProvider dbProvider = DBProvider("TIPS");
    Database database = await dbProvider.database;
    List<Map<String, dynamic>> result = await database.query('TIPS');

    return result.map((row) {
      return Tip.fromDb(row);
    }).toList();
  }

  // Edit the category of a specific tip in the database
  editTipCategory(title, time, text, newCategory) async {
    DBProvider dbProvider = DBProvider("TIPS");
    dbProvider.editTipCategory(title, time, text, newCategory);
  }
}

// Singleton class for managing the database
class DBProvider {
  final String dbName; // Database name
  static final Map<String, DBProvider> _instances = {}; // Singleton instances

  // Private constructor to enforce singleton pattern
  DBProvider._internal(this.dbName);

  // Factory method to get or create a singleton instance of DBProvider
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

  // Getter method to access the database instance
  Future<Database> get database async {
    // Directory documentsDirectory = await getApplicationSupportDirectory();
    // String path = join(documentsDirectory.path, "$dbName.db");
    // await deleteDatabase(path);


    if (_database != null) return _database!;
    _database = await _initDB();

    return _database!;

  }

  // Initialize the database and create the 'TIPS' table if not exists
  _initDB() async {
    Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = join(documentsDirectory.path, "$dbName.db");
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE TIPS (title TEXT PRIMARY KEY, ' 'time TEXT, ' 'text TEXT, ' 'category TEXT)');
      await _insertInitialData(db);
    });
  }

  // Insert initial data (tips) into the 'TIPS' table
  _insertInitialData(Database db) async {
    // Database db = await database;
    await db.transaction((txn) async {
      await db.rawInsert(
        "INSERT INTO TIPS (title, time, text, category) VALUES (?, ?, ?, ?)",
        ["Maintain a budget #1", "1-2 hours per month", "Set a monthly budget and track expenses. "
                                                        "Define financial goals and priorities to allocate funds properly. "
                                                        "Develop a detailed budget, including housing, food, debt, and savings. "
                                                        "Ensure your income covers these expenses. "
                                                        "Regularly monitor spending and make adjustments if needed to manage your money effectively and achieve financial goals.",
                                                        "None"],
      );
      await db.rawInsert(
        "INSERT INTO TIPS (title, time, text, category) VALUES (?, ?, ?, ?)",
        ["Create an emergency fund", "1-2 hours", "Building an emergency fund is vital for financial stability. "
                                                  "It serves as a safety net during unexpected situations like medical emergencies or job loss. "
                                                  "Aim to save three to six months' worth of living expenses. "
                                                  "Set a realistic goal, create a separate savings account, cut unnecessary expenses, and automate monthly contributions. "
                                                  "Financial security starts with planning – start your emergency fund today.",
                                                  "None"],
      );

      await db.rawInsert(
        "INSERT INTO TIPS (title, time, text, category) VALUES (?, ?, ?, ?)",
        ["Analyze your spending", "3-4 hours per day", "Analyzing spending is essential for financial stability. "
                                                      "Track all expenses, use budgeting tools, and categorize spending. "
                                                      "Review statements, identify patterns, and cut costs. "
                                                      "Set clear goals, create a budget, and prioritize savings. "
                                                      "Be mindful of expenses, avoid impulse buying, and adjust habits as needed. "
                                                      "This approach enables informed financial decisions and goal achievement.",
                                                      "None"],
      );
      await db.rawInsert(
        "INSERT INTO TIPS (title, time, text, category) VALUES (?, ?, ?, ?)",
        ["Maintain a budget #2", "1-2 hours per month", "Maintaining a budget is fundamental for financial control. "
                                                        "Track income and expenses, categorize spending, and allocate funds wisely. "
                                                        "Regularly review and adjust the budget based on changing financial circumstances. "
                                                        "Prioritize essential expenses, save for emergencies, and limit discretionary spending. "
                                                        "Adhering to a budget promotes financial stability, helps achieve goals, and ensures a secure financial future.",
                                                        "None"],
      );
      await db.rawInsert(
        "INSERT INTO TIPS (title, time, text, category) VALUES (?, ?, ?, ?)",
        ["Invest Wisely for the Future", "2-3 hours", "Invest your money wisely to make it work for you. "
                                                      "Understand different investment options such as stocks, bonds, and mutual funds. "
                                                      "Diversify your investments to spread the risk. "
                                                      "Consider consulting a financial advisor to make informed decisions.",
                                                      "None"],
      );
      await db.rawInsert(
        "INSERT INTO TIPS (title, time, text, category) VALUES (?, ?, ?, ?)",
        ["Eliminate High-Interest Debt", "2-3 hours", "High-interest debt, like credit card balances, can drain your finances. "
                                                      "Create a plan to pay off these debts as quickly as possible. "
                                                      "Prioritize high-interest debts while making minimum payments on others. "
                                                      "This strategy saves money in the long run and.", "None"],
      );
      await db.rawInsert(
        "INSERT INTO TIPS (title, time, text, category) VALUES (?, ?, ?, ?)",
        ["Live Below Your Means", "1-3 hours", "Avoid lifestyle inflation by living below your means. "
                                                "Assess your needs versus wants and make conscious spending choices. "
                                                "Budget carefully, distinguishing between essential and non-essential expenses. "
                                                "By spending less than you earn, you'll have more resources for saving, investing, and handling unexpected expenses.",
                                                "None"],
      );
    });
  }

  // Update the category of a specific tip in the 'TIPS' table
  editTipCategory(title, time, text, newCategory) async {
    Database db = await database;
    await db.update(
      'TIPS',
      {
        'title': title,
        'time': time,
        'text': text,
        'category':newCategory,
      },
      where: 'title = ?',
      whereArgs: [title],
    );
  }


}