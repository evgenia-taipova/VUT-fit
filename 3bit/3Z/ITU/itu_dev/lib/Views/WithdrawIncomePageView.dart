/*
==============================================================================================================
  File: WithdrawIncomePageView.dart
  Author: Dinara Garipova (xgarip00)

  This widget represents the page where users can withdraw an income. It provides an input field for users
  to enter the withdrawal amount and a button to perform the withdrawal. The updated income amount is calculated
  and the user is navigated back to the IncomesPageView after the withdrawal.
=================================================================================================================
*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itu_dev/Models/BalancePageModel.dart';
import 'package:itu_dev/Models/IncomesPageModel.dart';
import '../Controllers/IncomesPageController.dart';
import 'BottomNavigationBarWidgetView.dart';
import 'IncomesPageView.dart';

// This class represents the page where users can withdraw an income.
class WithdrawIncomePageView extends StatefulWidget {
  // Constructor to initialize the page with necessary data.
  const WithdrawIncomePageView({
    Key? key,
    required this.income,
    required this.walletId,
    required this.balance,
    required this.title,
  }) : super(key: key);

  // Properties to store income details, wallet ID, balance, and title.
  final Income income;
  final int walletId;
  final Balance balance;
  final String title;

  // Overrides createState to create the mutable state for the widget.
  @override
  State<WithdrawIncomePageView> createState() => _WithdrawPageViewState();
}

// The mutable state for the WithdrawIncomePageView widget.
class _WithdrawPageViewState extends State<WithdrawIncomePageView> {
  // Controller for managing income-related data.
  final IncomesPageController _controller = IncomesPageController();
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
        // Leading icon button to navigate back to the IncomesPageView.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _controller.gotoPage(IncomesPageView(title: widget.title, balance: widget.balance, walletId: widget.walletId,), context);
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
                  amountToWithdraw = widget.income.amount - amountToWithdraw;
                  // Edit the income with the updated amount.
                  _controller.edit(widget.income.id, widget.income.name, amountToWithdraw, widget.income.color, widget.income.icon);
                  // Navigate back to the IncomesPageView.
                  _controller.gotoPage(Builder(
                      builder: (context) {
                        return IncomesPageView(title: "Incomes", balance: widget.balance, walletId: widget.walletId,);
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
