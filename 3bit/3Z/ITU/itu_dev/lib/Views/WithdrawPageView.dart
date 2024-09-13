/*
=================================================================================================================
  File: WithdrawPageView.dart
  Author: Dinara Garipova (xgarip00)

  This widget represents the page where users can withdraw an expense. It provides an input field for users
  to enter the withdrawal amount and a button to perform the withdrawal. The updated expense amount is calculated
  and the user is navigated back to the ExpensesPageView after the withdrawal.
==================================================================================================================
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itu_dev/Models/BalancePageModel.dart';
import 'package:itu_dev/Models/ExpensesPageModel.dart';
import '../Controllers/ExpensesPageController.dart';
import 'BottomNavigationBarWidgetView.dart';
import 'ExpensesPageView.dart';

// This class represents the page where users can withdraw an expense.
class WithdrawPageView extends StatefulWidget {
  // Constructor to initialize the page with necessary data.
  const WithdrawPageView({
    Key? key,
    required this.expense,
    required this.walletId,
    required this.balance,
    required this.title,
  }) : super(key: key);

  // Properties to store expense details, wallet ID, balance, and title.
  final Expense expense;
  final int walletId;
  final Balance balance;
  final String title;

  // Overrides createState to create the mutable state for the widget.
  @override
  State<WithdrawPageView> createState() => _WithdrawPageViewState();
}

// The mutable state for the WithdrawPageView widget.
class _WithdrawPageViewState extends State<WithdrawPageView> {
  // Controller for managing expense-related data.
  final ExpensesPageController _controller = ExpensesPageController();
  // Variable to store the new amount entered by the user.
  String newAmount = "";

  // Build method to create the widget tree.
  @override
  Widget build(BuildContext context) {
    // Scaffold widget represents the basic structure of the visual interface.
    return Scaffold(
      // AppBar at the top of the screen.
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: const Color.fromARGB(255, 87, 80, 147),
        title: const Text("Withdraw", style: TextStyle(fontSize: 28, color: Colors.white)),
        // Leading icon button to navigate back to the ExpensesPageView.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _controller.gotoPage(ExpensesPageView(title: widget.title, walletId: widget.walletId, balance: widget.balance),context);
          },
        ),
      ),
      // Body of the screen containing input fields and withdrawal button.
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Input field for entering the withdrawal amount.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (text) {
                  newAmount = text;
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            // GestureDetector for handling the withdrawal action.
            GestureDetector(
              onTap: () async {
                if (newAmount.isNotEmpty) {
                  // Parse the new amount and calculate the updated amount after withdrawal.
                  num amountToWithdraw = num.tryParse(newAmount) ?? 0;
                  amountToWithdraw = widget.expense.amount - amountToWithdraw;
                  // Edit the expense with the updated amount.
                  _controller.edit(widget.expense.id, widget.expense.name, amountToWithdraw, widget.expense.color, widget.expense.icon);
                  // Navigate back to the ExpensesPageView.
                  _controller.gotoPage(Builder(
                      builder: (context) {
                        return ExpensesPageView(title: "Expenses", balance: widget.balance, walletId: widget.walletId);
                      }
                  ), context);
                }
              },
              // Container for the withdrawal button.
              child: Container(
                height: 45.0,
                width: 164.0,
                decoration: BoxDecoration(
                  color: const Color(0xFFC27C9C),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Withdraw",
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
      // Bottom navigation bar widget.
      bottomNavigationBar: BottomNavigationBarWidgetView(),
    );
  }
}
