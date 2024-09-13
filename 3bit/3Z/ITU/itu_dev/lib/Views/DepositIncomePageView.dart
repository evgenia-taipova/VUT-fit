/*
=========================================================================================================
File: DepositIncomePageView.dart
Author: Dinara Garipova (xgarip00)

This Dart file defines a StatefulWidget class, DepositIncomePageView, representing the page for depositing income.
Users can input the amount to be deposited, and the deposited amount will be added to the current income.
==========================================================================================================
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itu_dev/Models/BalancePageModel.dart';
import 'package:itu_dev/Models/IncomesPageModel.dart';
import '../Controllers/IncomesPageController.dart';
import 'BottomNavigationBarWidgetView.dart';
import 'IncomesPageView.dart';

// StatefulWidget for handling the deposit of income.
class DepositIncomePageView extends StatefulWidget {
  // Properties to hold income details, wallet information, and page title.
  final Income income;
  final int walletId;
  final Balance balance;
  final String title;

  // Constructor to initialize the properties when creating an instance of the class.
  const DepositIncomePageView({
    Key? key,
    required this.income,
    required this.walletId,
    required this.balance,
    required this.title,
  }) : super(key: key);

  @override
  State<DepositIncomePageView> createState() => _DepositPageViewState();
}

// State class for the DepositIncomePageView.
class _DepositPageViewState extends State<DepositIncomePageView> {
  // Instance of IncomesPageController for handling page navigation and actions.
  final IncomesPageController _controller = IncomesPageController();

  // Variable to hold the new amount entered by the user.
  String newAmount = "";

  // Build method to create the UI for the deposit income page.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold widget for overall page structure.
      appBar: AppBar(
        // App bar containing the title and back button.
        toolbarHeight: 120,
        backgroundColor: const Color.fromARGB(255, 87, 80, 147),
        title: const Text("Deposit", style: TextStyle(fontSize: 28, color: Colors.white)),
        leading: IconButton(
          // Back button to navigate to the previous page.
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _controller.gotoPage(IncomesPageView(title: widget.title, walletId: widget.walletId, balance: widget.balance),context);
          },
        ),
      ),
      body: SingleChildScrollView(
        // SingleChildScrollView to enable scrolling when the keyboard is open.
        child: Column(
          children: [
            // Text field for entering the deposit amount.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (text) {
                  setState(() {
                    newAmount = text;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            // GestureDetector for handling the 'Add' button tap.
            GestureDetector(
              onTap: () async {
                // Check if the entered amount is not empty.
                if (newAmount.isNotEmpty) {
                  // Parse the entered amount to a numeric value or default to 0.
                  num amountToAdd = num.tryParse(newAmount) ?? 0;
                  // Calculate the new total amount after deposit.
                  amountToAdd = widget.income.amount + amountToAdd;

                  // Edit the income with the new amount.
                  _controller.edit(
                    widget.income.id,
                    widget.income.name,
                    amountToAdd,
                    widget.income.color,
                    widget.income.icon,
                  );
                  // Navigate to the IncomesPageView after deposit.
                  _controller.gotoPage(
                    Builder(
                        builder: (context) {
                          return IncomesPageView(title: "Incomes", balance: widget.balance, walletId: widget.walletId,);
                        }
                    ),
                    context,
                  );
                }
              },
              child: Container(
                // Container for the 'Add' button.
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
      // Bottom navigation bar widget for page navigation.
      bottomNavigationBar: BottomNavigationBarWidgetView(),
    );
  }
}
