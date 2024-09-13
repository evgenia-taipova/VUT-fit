/*
=========================================================================================================
File: expense_item_widget.dart
Author: Dinara Garipova (xgarip00)

This Dart file defines a StatelessWidget class, ExpenseItemWidget, representing a single expense item in a list.
It displays the expense information, including color, name, amount, and icon.
==========================================================================================================
*/
import 'package:flutter/material.dart';

// A StatelessWidget representing a single expense item in a list.
class ExpenseItemWidget extends StatelessWidget {
  // Properties to hold information about the expense.
  final int color;    // Color code for the expense category.
  final String name;  // Name of the expense.
  final num amount;   // Amount of the expense.
  final int icon;     // Icon code for the expense category.

  // Constructor to initialize the properties when creating an instance of the class.
  const ExpenseItemWidget({
    super.key,
    required this.color,
    required this.name,
    required this.amount,
    required this.icon,
  });

  // Build method to create the UI for the expense item.
  @override
  Widget build(BuildContext context) {
    // ListTile widget to display the expense information in a list.
    return ListTile(
      // Leading section displaying a colored circle with the expense icon.
      leading: Container(
        width: 48.0,
        height: 48.0,
        decoration: BoxDecoration(
          color: Color(color),
          shape: BoxShape.circle,
        ),
        child: Icon(
          IconData(icon, fontFamily: 'MaterialIcons'),
          color: Colors.black,
          size: 24.0,
        ),
      ),
      // Title section displaying the name of the expense.
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'MiriamLibre',
          fontSize: 20.0,
        ),
      ),
      // Trailing section displaying the amount of the expense.
      trailing: Text(
        amount.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'MiriamLibre',
          fontSize: 20.0,
        ),
      ),
    );
  }
}
