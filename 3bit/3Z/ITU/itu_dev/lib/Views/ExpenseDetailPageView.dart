/*
=========================================================================================================
File: ExpenseDetailsPageView.dart
Author: Dinara Garipova (xgarip00)

This Dart file defines a StatelessWidget class, ExpenseDetailsPageView, representing the details page for a specific expense.
The page displays information about the expense, provides options to deposit or withdraw from the expense, and allows editing or deleting the expense.
==========================================================================================================
*/
import 'package:flutter/material.dart';
import 'package:itu_dev/Models/BalancePageModel.dart';
import 'package:itu_dev/Views/EditExpensePageView.dart';
import '../Controllers/ExpensesPageController.dart';
import '../Models/ExpensesPageModel.dart';
import 'DepositPageView.dart';
import 'ExpensesPageView.dart';
import 'WithdrawPageView.dart';

// This class represents the page for displaying details of a specific expense.
class ExpenseDetailsPageView extends StatelessWidget {
  // Properties to hold the expense details, wallet information, and page title.
  final Expense expense;
  final Balance balance;
  final int walletId;
  final String title;

  // Constructor to initialize the properties when creating an instance of the class.
  ExpenseDetailsPageView({
    Key? key,
    required this.expense,
    required this.walletId,
    required this.balance,
    required this.title,
  }) : super(key: key);

  // Instance of the ExpensesPageController for handling page navigation and actions.
  final ExpensesPageController _controller = ExpensesPageController();

  // Build method to create the UI for the expense details page.
  @override
  Widget build(BuildContext context) {
    // Define button styles for UI consistency.
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
    final ButtonStyle deleteButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 247, 73, 73),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );

    return Scaffold(
      // Scaffold widget for overall page structure.
      appBar: AppBar(
        // App bar containing the page title and navigation icons.
        title: const Text(
          'Expense',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF575093),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          // Back button to navigate to the previous page.
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _controller.gotoPage(
              ExpensesPageView(title: title, walletId: walletId, balance: balance),
              context,
            );
          },
        ),
      ),
      body: Padding(
        // Padding for content spacing.
        padding: const EdgeInsets.all(16.0),
        child: Align(
          // Align widget for centering content vertically.
          alignment: const Alignment(0.0, -0.5),
          child: Column(
            // Column widget to organize content vertically.
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Display the expense details in a Card widget.
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color(expense.color),
                  ),
                  height: 80.0,
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 25.0, right: 22.0, top: 15.0),
                    title: Text(
                      expense.name,
                      style: const TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                    trailing: Text(
                      expense.amount.toString(),
                      style: const TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                ),
              // ButtonBar for organizing deposit and withdraw buttons horizontally.
              ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Deposit button to navigate to the DepositPageView.
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () {
                      _controller.gotoPage(
                        DepositPageView(
                          expense: expense,
                          balance: balance,
                          walletId: walletId,
                          title: title,
                        ),
                        context,
                      );
                    },
                    child: Container(
                      height: 45.0,
                      width: 120.0,
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
                  // Withdraw button to navigate to the WithdrawPageView.
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () {
                      _controller.gotoPage(
                        WithdrawPageView(
                          expense: expense,
                          balance: balance,
                          walletId: walletId,
                          title: title,
                        ),
                        context,
                      );
                    },
                    child: Container(
                      height: 45.0,
                      width: 120.0,
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
              // ButtonBar for organizing edit and delete buttons horizontally.
              ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  // Edit button to navigate to the EditExpensePageView.
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () {
                      _controller.gotoPage(
                        EditExpensePageView(
                          expense: expense,
                          balance: balance,
                          walletId: walletId,
                          title: title,
                        ),
                        context,
                      );
                    },
                    child: Container(
                      height: 45.0,
                      width: 120.0,
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
                  // Delete button to delete the expense and navigate to the ExpensesPageView.
                  ElevatedButton(
                    style: deleteButtonStyle,
                    onPressed: () {
                      _controller.dellExpense(expense.id);
                      _controller.gotoPage(
                        ExpensesPageView(title: title, balance: balance, walletId: walletId),
                        context,
                      );
                    },
                    child: Container(
                      height: 45.0,
                      width: 120.0,
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
          ),
        ),
      ),
    );
  }
}
