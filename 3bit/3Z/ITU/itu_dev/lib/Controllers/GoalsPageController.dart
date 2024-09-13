// File: GoalsPageController.dart
// Author: Taipova Evgeniya (xtaipo00)
// Description:  This file defines the GoalsPageController class, responsible for handling the application's
// goals-related logic. It interacts with the GoalsPageModel to manage the CRUD operations for goals,
// calculates goal progress, and prepares the UI components for rendering goals.

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:itu_dev/Models/GoalsPageModel.dart';
import 'package:itu_dev/Views/GoalsEditDeletePage.dart';
import 'package:intl/intl.dart';

class GoalsPageController extends ControllerMVC{
  final GoalsPageModel _model = GoalsPageModel();
  factory GoalsPageController(){
    _this ??= GoalsPageController._();
    return _this;
  }

  static GoalsPageController _this = GoalsPageController._();
  GoalsPageController._();

  // Draws a list of goals in a Column widget.
  Future<Column> drawBubbleGoal(context, colorAlfa) async{
    List<Widget> widgets;
    List<Goal> goals = await _model.loadDBData();
    widgets = goals.map((goal) {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              _this.gotoPage(GoalsEditDeletePage(id: goal.id, name: goal.name, goalAmount: goal.goalAmount, amount: goal.amount, date: goal.date), context);
            },
            child: _this.drawContainerGoals(101.0,372.0, colorAlfa, goal),
          ),
          const SizedBox(height: 16.0),
        ],
      );
    }).toList();
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: widgets);
  }

  // Draws goals for the main page.
  Future<Column> drawGoalsForMain(colorAlfa) async{
    List<Widget> widgets;
    List<Goal> goals = await _model.loadDBData();
    widgets = goals.map((goal) {
      return Column(
        children: [
          _this.drawContainerGoals(60.0, 372.0, colorAlfa, goal),
          const SizedBox(height: 3.0),
        ],
      );
    }).toList();
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: widgets);
  }

  // Navigates to a new page.
  void gotoPage(pageObj, context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pageObj),
    );
  }

  // Calculates the number of days until a specific date.
  int daysUntil(String date) {
    final DateTime targetDate = DateFormat('dd-MM-yyyy').parse(date);
    final DateTime now = DateTime.now();
    return targetDate.difference(now).inDays;
  }

  // Adds the specified amount to a goal.
  void addToGoal(int id, String name, String goalAmount, String amount, String date, String newAmount) async {
    if (newAmount.isNotEmpty) {
      int amountToAdd = int.tryParse(newAmount) ?? 0;
      int updatedAmount = int.parse(amount) + amountToAdd;

      edit(id, name, goalAmount, updatedAmount, date);

    }
  }
// Deducts the specified amount from a goal.
  void deductFromGoal(int id, String name, String goalAmount, String amount, String date, String newAmount) async {
    if (newAmount.isNotEmpty) {
      int amountToDeduct = int.tryParse(newAmount) ?? 0;
      int updatedAmount = int.parse(amount) - amountToDeduct;

      edit(id, name, goalAmount, updatedAmount, date);
    }
  }

  // Calculates the percentage of a goal achieved.
  double calculatePercentage(String collected, String goal) {
    double collectedAmount = double.tryParse(collected) ?? 0.0;
    double goalAmount = double.tryParse(goal) ?? 0.0;
    if (goalAmount == 0.0) return 0.0;
    return (collectedAmount / goalAmount) * 100;
  }

  // Draws a container for displaying a goal.
  Container drawContainerGoals(height,width, colorAlfa, goal){

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Color.fromARGB(colorAlfa, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    goal.name,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "${goal.amount}/${goal.goalAmount}",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                "${goal.date} (${daysUntil(goal.date)} days left)",
                style: const TextStyle(
                  color: Color.fromARGB(150, 78, 77, 77),
                  fontSize: 12,
                ),
              ),
                    Text(
                      "(${calculatePercentage(goal.amount, goal.goalAmount).toStringAsFixed(2)}% collected)",
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
              ),
            ),
          ],
        ),
      ),
    );
  }

 // Deletes a goal from the database.
  void dellGoal(id){
    _model.dellGoalFromDB(id);
  }

  // Saves a new goal to the database.
  void saveGoal(name,goalAmount, amount,  date){
    _model.addGoalToDb(name, goalAmount, amount,date);
  }

  // Edits a goal in the database.
  void edit(id, newName, newGoalAmount, newAmount, newDate){
    _model.editGoalInDB(id, newName, newGoalAmount, newAmount,  newDate);
  }
}
