/*
=========================================================================================================
File: IncomeItemWidget.dart
Author: Dinara Garipova (xgarip00)

This Dart file defines a StatelessWidget class, IncomeItemWidget, representing an item for displaying
income in a list. It includes properties for color, name, amount, and icon of the income, and a build
method to create the UI for the income item.
==========================================================================================================
*/
import 'package:flutter/material.dart';

// Widget for displaying an item representing income in a list.
class IncomeItemWidget extends StatelessWidget {
  final int color;
  final String name;
  final num amount;
  final int icon;

  // Constructor for the IncomeItemWidget.
  const IncomeItemWidget({
    Key? key,
    required this.color,
    required this.name,
    required this.amount,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Leading section with a colored circle and income icon.
      leading: Container(
        width: 48.0,
        height: 48.0,
        decoration: BoxDecoration(
          color: Color(color),
          shape: BoxShape.circle,
        ),
        child: Icon(
          // Display income icon using IconData.
          IconData(icon, fontFamily: 'MaterialIcons'),
          color: Colors.black,
          size: 24.0,
        ),
      ),
      // Title section displaying the name of the income.
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'MiriamLibre',
          fontSize: 20.0,
        ),
      ),
      // Trailing section displaying the amount of the income.
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
