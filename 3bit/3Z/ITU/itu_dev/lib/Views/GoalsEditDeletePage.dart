// File: GoalsEditDeletePage.dart
// Author: Taipova Evgeniya (xtaipo00)
// Description: This file contains the implementation of the GoalsEditDeletePage class,
// which allows users to edit, delete, and manage their financial goals in the finance application.


import 'package:flutter/material.dart';
import 'package:itu_dev/Controllers/GoalsPageController.dart';
import 'package:itu_dev/Views/GoalsEditPageView.dart';
import 'package:itu_dev/Views/GoalsPageView.dart';
import 'package:itu_dev/Views/GoalPlusPageView.dart';
import 'package:itu_dev/Views/GoalMinusPageView.dart';

class GoalsEditDeletePage extends StatefulWidget{

  const GoalsEditDeletePage({
    super.key,
    required this.id,
    required this.name,
    required this.goalAmount,
    required this.amount,
    required this.date,
  });

  final id;
  final name;
  final goalAmount;
  final amount;
  final date;


  @override
  State<GoalsEditDeletePage> createState() => _GoalsEditDeletePageState();
}

class _GoalsEditDeletePageState extends State<GoalsEditDeletePage>{
  final GoalsPageController _controller = GoalsPageController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 120,
          title: const Text("Your Goal", style: TextStyle(fontSize: 28, color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            // Navigate back to the GoalsPageView when the back button is pressed.
            onPressed:  (){_controller.gotoPage(const GoalsPageView(title: "My Goals"), context);},
          ),
        ),
        body: Center(
            child: Column(
              children: [
                // Displaying goal information in a container.
                Container(
                  height: 101.0,
                  width: 372.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Displaying goal name and current progress.
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "${widget.amount}/${widget.goalAmount}",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Displaying goal deadline, days left, and percentage collected.
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "${widget.date} (${_controller.daysUntil(widget.date)} days left)",
                                style: const TextStyle(
                                  color: Color.fromARGB(150, 78, 77, 77),
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                "(${_controller.calculatePercentage(widget.amount, widget.goalAmount).toStringAsFixed(2)}% collected)",
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
                ),
                const SizedBox(height: 16.0),
                // Buttons for Deposit and Withdraw actions.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        // Navigate to GoalPlusPageView when the Deposit button is tapped.
                        _controller.gotoPage(GoalPlusPageView(id: widget.id, name: widget.name, goalAmount: widget.goalAmount, amount:widget.amount, date: widget.date), context);
                      },
                      child: Container(
                        height: 45.0,
                        width: 164.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Text(
                                    "Deposit",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ]
                            )
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    GestureDetector(
                      onTap: (){
                        // Navigate to GoalMinusPageView when the Withdraw button is tapped.
                        _controller.gotoPage(GoalMinusPageView(id: widget.id, name: widget.name,  goalAmount: widget.goalAmount, amount:widget.amount, date: widget.date), context);
                      },
                      child: Container(
                        height: 45.0,
                        width: 164.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Text(
                                    "Withdraw",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ]
                            )
                        ),
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 16.0),
                // Buttons for Edit and Delete actions.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        // Navigate to GoalsEditPageView when the Edit button is tapped.
                        _controller.gotoPage(GoalsEditPageView(id: widget.id, name: widget.name, goalAmount: widget.goalAmount, amount:widget.amount, date: widget.date), context);
                      },
                      child: Container(
                        height: 45.0,
                        width: 164.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Text(
                                    "Edit",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(width: 9.0),
                                  Icon(Icons.edit, size: 25,)
                                ]
                            )
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    GestureDetector(
                      onTap: (){
                        // Delete the goal and navigate back to GoalsPageView when the Delete button is tapped.
                        _controller.dellGoal(widget.id);
                        _controller.gotoPage(const GoalsPageView(title: "My Goal"), context);
                      },
                      child: Container(
                        height: 45.0,
                        width: 164.0,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 247, 73, 73),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Text(
                                    "Delete",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(width: 9.0),
                                  Icon(Icons.delete, size: 25,)
                                ]
                            )
                        ),
                      ),
                    ),

                  ],
                ),



              ],
            )
        )
    );
  }
}
