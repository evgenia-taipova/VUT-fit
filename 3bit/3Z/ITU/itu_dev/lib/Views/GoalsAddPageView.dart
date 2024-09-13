// File: GoalsAddPageView.dart
// Author: Taipova Evgeniya (xtaipo00)
// Description: This file contains the implementation of the GoalsAddPageView class,
// which is responsible for adding new goals in the finance application.

import 'package:flutter/material.dart';
import 'package:itu_dev/Views/GoalsPageView.dart';
import 'package:itu_dev/Controllers/GoalsPageController.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class GoalsAddPageView extends StatefulWidget {
  const GoalsAddPageView({super.key, required this.title});

  final String title;

  @override
  State<GoalsAddPageView> createState() => _GoalsAddPageViewState();
}

class _GoalsAddPageViewState extends State<GoalsAddPageView>{
  final GoalsPageController _controller = GoalsPageController();
  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context){
    // Initialize variables to store user input.
    String name="";
    String goalAmount="";
    String amount="";

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text(widget.title, style: const TextStyle(fontSize: 28, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed:  (){_controller.gotoPage(const GoalsPageView(title: "My Goal"), context);},
        ),
        actions: <Widget>[
          // Save button to save the entered goal.
          TextButton(
              child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 20)),
              onPressed: (){
                if (name.isEmpty || goalAmount.isEmpty || amount.isEmpty || dateController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  _controller.saveGoal(name, goalAmount, amount, dateController.text);
                  _controller.gotoPage(const GoalsPageView(title: "My Goal"), context);
                }
              }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Text field for entering the name of the goal.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (text){name=text;},
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
            // Text field for entering the goal amount.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (text) {
                  goalAmount = text;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
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
            // Text field for entering the collected amount.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (text) {
                  amount = text;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
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
            // Text field for selecting the date.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: dateController,
                readOnly: true,
                style: const TextStyle(color: Colors.white),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2022),  // Start date
                    lastDate: DateTime(2025),   // End date
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
                  labelText: 'Date',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
