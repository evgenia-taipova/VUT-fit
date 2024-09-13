// File: GoalPlusPageView.dart
// Author: Taipova Evgeniya (xtaipo00)
// Description: This file contains the implementation of the GoalPlusPageView class,
// which is responsible for allowing users to deposit money into their financial goals.


import 'package:flutter/material.dart';
import 'package:itu_dev/Views/GoalsPageView.dart';
import 'package:itu_dev/Views/BottomNavigationBarWidgetView.dart';
import 'package:itu_dev/Controllers/GoalsPageController.dart';

class GoalPlusPageView extends StatefulWidget {
  const GoalPlusPageView({
    super.key,
    required this.id,
    required this.name,
    required this.amount,
    required this.goalAmount,
    required this.date,
  });

  final id;
  final name;
  final goalAmount;
  final amount;
  final date;

  @override
  State<GoalPlusPageView> createState() => _GoalPlusPageViewState();
}

class _GoalPlusPageViewState extends State<GoalPlusPageView> {
  final GoalsPageController _controller = GoalsPageController();
  late String newAmount;

  @override
  void initState() {
    super.initState();
    newAmount = widget.amount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: const Color.fromARGB(255, 87, 80, 147),
        title: const Text("Deposit", style: TextStyle(fontSize: 28, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _controller.gotoPage(const GoalsPageView(title: "My Goals"), context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Text field for entering the amount to add.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  setState(() {
                    newAmount = text;
                  });
                },
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                  ),
                  labelText: 'Amount to Add',
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            // Button to add the specified amount to the goal.
            GestureDetector(
              onTap:  () {
                _controller.addToGoal(
                  widget.id,
                  widget.name,
                  widget.goalAmount,
                  widget.amount,
                  widget.date,
                  newAmount,
                );
                _controller.gotoPage(const GoalsPageView(title: "My Goals"), context);
              },

              child: Container(
                height: 45.0,
                width: 164.0,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 98, 203, 153),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Add",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidgetView(),
    );
  }
}
