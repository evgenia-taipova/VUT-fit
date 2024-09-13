// File: BalanceAddPageView.dart
// Author: Taipova Evgeniya (xtaipo00)
// Description: This file contains the implementation of the BalanceAddPageView class,
// which allows users to add a new balance entry.

import 'package:flutter/material.dart';
import '../Controllers/BalancePageController.dart';
import 'BalancePageView.dart';

class BalanceAddPageView extends StatefulWidget {
  const BalanceAddPageView({super.key, required this.title});

  final String title;

  @override
  State<BalanceAddPageView> createState() => _BalanceAddPageViewState();
}

class _BalanceAddPageViewState extends State<BalanceAddPageView>{
  final BalancePageController _controller = BalancePageController();

  @override
  Widget build(BuildContext context){
    // Initialize variables to store user input.
    String name = "";
    String amount = "";

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text(widget.title, style: const TextStyle(fontSize: 28, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:  (){_controller.gotoPage(const BalancePageView(title: "My Balance"), context);},
        ),
        actions: <Widget>[
          // Save button to save the entered balance.
          TextButton(
              child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 20)),
              onPressed: (){
                // Check if both fields are filled out
                if (name.isEmpty || amount.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  // Save the balance with the given name and amount
                  _controller.saveBalance(name, amount);
                  // Navigate back to the BalancePageView
                  _controller.gotoPage(const BalancePageView(title: "My Balance"), context);
                }
              }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Input field for entering the name
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
                  labelText: 'Name',
                ),
              ),
            ),
            // Input field for entering the amount
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                onChanged: (text){amount = text;} ,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
                  border: OutlineInputBorder(),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                  ),
                  labelText: 'Amount',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
