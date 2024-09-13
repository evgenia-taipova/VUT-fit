/*
=========================================================================================================
File: ExpensesPageController.dart
Author: Dinara Garipova (xgarip00)

This Dart file defines a controller class, ExpensesPageController, using the MVC pattern.
It extends the ControllerMVC class from the 'mvc_pattern' package and interacts with the ExpensesPageModel.
The controller is responsible for managing the logic related to the ExpensesPage view.
==========================================================================================================
*/
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:itu_dev/Models/ExpensesPageModel.dart';

// ExpensesPageController is the controller class for the ExpensesPage
class ExpensesPageController extends ControllerMVC {
  // Instance of the ExpensesPageModel for handling expense-related operations
  final ExpensePageModel _model = ExpensePageModel();

  // Singleton instance variable
  factory ExpensesPageController() {
    return _this;
  }

  static final ExpensesPageController _this = ExpensesPageController._();

  // Private constructor to prevent direct instantiation
  ExpensesPageController._();

  // Add an expense to the database
  Future<void> addExpenseToDb(
      int walletId, String name, num amount, int color, IconData icon, DateTime creationDate) async {
    await _model.addExpenseToDb(walletId, name, amount, color, icon, creationDate);
  }

  // Load all expenses from the database and return a list
  Future<List<Expense>> drawBubble(context, colorAlfa) async {
    return _model.loadDBData();
  }

  // Navigate to a specified page and replace the current page
  void gotoPage(pageObj, context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pageObj),
    );
  }

  // Delete an expense by its ID
  void dellExpense(id) {
    _model.deleteExpenseFromDB(id);
  }

  // Save a new expense to the database
  void save(walletId, name, amount, color, icon, creationDate) {
    _model.addExpenseToDb(walletId, name, amount, color, icon, creationDate);
  }

  // Edit an existing expense in the database
  void edit(id, newName, newAmount, newColor, newIcon) {
    _model.editExpenseInDB(id, newName, newAmount, newColor, newIcon);
  }

  // Calculate the total expense for the current month
  // Function provided by xkulin01
  Future<num> calculateTotalExpenses() async {
    List<Expense> expenses = await _model.loadDBData();
    DateTime currentDate = DateTime.now();
    List<Expense> expensesForCurrentMonth = expenses.where((expense) {
      return expense.creationDate.year == currentDate.year &&
          expense.creationDate.month == currentDate.month;
    }).toList();
    num totalExpensesForCurrentMonth = expensesForCurrentMonth.fold<num>(
      0.0,
          (num sum, Expense expense) => sum + expense.amount,
    );
    return totalExpensesForCurrentMonth;
  }

  // Calculate the total expense for each of the last 7 days
  // Function provided by xkulin01
  Future<List<num>> calculateTotalExpensesPerDay() async {
    List<Expense> expenses = await _model.loadDBData();
    DateTime currentDate = DateTime.now();
    List<num> totalExpensesPerDay = List<num>.generate(7, (index) {
      DateTime date = currentDate.subtract(Duration(days: index));
      List<Expense> expensesForDay = expenses.where((expense) {
        return expense.creationDate.year == date.year &&
            expense.creationDate.month == date.month &&
            expense.creationDate.day == date.day;
      }).toList();
      num totalExpenseForDay = expensesForDay.fold<num>(
        0.0,
            (num sum, Expense expense) => sum + expense.amount,
      );
      return totalExpenseForDay;
    });
    return totalExpensesPerDay;
  }
}
