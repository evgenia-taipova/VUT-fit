// File: GoalsEditPageView.dart
// Author: Taipova Evgeniya (xtaipo00)
// Description: This file contains the implementation of the GoalsEditPageView class,
// which allows users to edit their financial goals in the finance application.

import 'package:flutter/material.dart';
import 'package:itu_dev/Views/GoalsPageView.dart';
import 'package:itu_dev/Views/GoalsEditDeletePage.dart';
import 'package:itu_dev/Controllers/GoalsPageController.dart';
import 'package:intl/intl.dart';

class GoalsEditPageView extends StatefulWidget {

  const GoalsEditPageView({
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
  State<GoalsEditPageView> createState() => _GoalsEditPageViewState();
}

class _GoalsEditPageViewState extends State<GoalsEditPageView> {
  final GoalsPageController _controller = GoalsPageController();
  late TextEditingController dateController;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(text: widget.date);
  }

  @override
  Widget build(BuildContext context) {
    String newName = widget.name;
    String newGoalAmount = widget.goalAmount;
    String newAmount = widget.amount;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: const Text("Edit", style: TextStyle(fontSize: 28, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed:  (){
            // Navigate back to GoalsEditDeletePage when the back button is pressed.
            _controller.gotoPage(GoalsEditDeletePage(id: widget.id, name: widget.name, goalAmount: widget.goalAmount,amount: widget.amount, date: widget.date), context);},
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 20)),
              onPressed: (){
                // Save the edited goal and navigate back to GoalsPageView.
                _controller.edit(widget.id, newName, newGoalAmount, newAmount, dateController.text);
                _controller.gotoPage(const GoalsPageView(title: "My Goals"), context);
              }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Text field for editing the name of the goal.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: TextEditingController(text: widget.name),
                onChanged: (text){newName=text;},
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
                  border: OutlineInputBorder(),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                  ),
                  labelText: 'Name of goal',
                ),
              ),
            ),
            // Text field for editing the goal amount.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: widget.goalAmount),
                onChanged: (text){newGoalAmount = text;} ,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
                  border: OutlineInputBorder(),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                  ),
                  labelText: 'Goal Amount',
                ),
              ),
            ),
            // Text field for editing the collected amount.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                controller: TextEditingController(text: widget.amount),
                onChanged: (text){newAmount = text;} ,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
                  border: OutlineInputBorder(),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                  ),
                  labelText: 'Collected Amount',
                ),
              ),
            ),
            // Text field for editing the desired date.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: dateController,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.date.isNotEmpty ? DateFormat('dd-MM-yyyy').parse(widget.date) : DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2025),
                  );
                  if (pickedDate != null) {
                    String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                    dateController.text = formattedDate;
                  }
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
                  labelText: 'Desire date',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
