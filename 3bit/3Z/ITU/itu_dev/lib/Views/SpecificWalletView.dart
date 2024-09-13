/*
===================================================================================================================
  File: SpecificWalletView.dart
  Author: Dinara Garipova (xgarip00)

  This widget represents the view for a specific wallet, displaying its balance and related information.
  It includes data for the title, balance, and wallet ID. The widget allows users to navigate to the expenses
  and incomes pages, view current week's financial data, and perform additional actions such as deleting the wallet.
======================================================================================================================
*/
import 'package:flutter/material.dart';
import 'package:itu_dev/Models/BalancePageModel.dart';
import 'package:itu_dev/Views/BalancePageView.dart';
import 'package:itu_dev/Controllers/SpecificWalletPageController.dart';
import '../Models/ExpensesPageModel.dart';
import '../Models/IncomesPageModel.dart';
import 'BottomNavigationBarWidgetView.dart';
import 'package:itu_dev/Views/ExpensesPageView.dart';
import 'package:itu_dev/Controllers/BalancePageController.dart';
import 'IncomesPageView.dart';

// The class represents the view for a specific wallet, displaying its balance and related information.
class SpecificWalletView extends StatefulWidget {
  // Constructor to initialize the view with necessary data.
  const SpecificWalletView({
    Key? key,
    required this.title,
    required this.balance,
    required this.walletId,
  }) : super(key: key);

  // Properties to store the title, balance, and wallet ID.
  final String title;
  final int walletId;
  final Balance balance;

  // Overrides createState to create the mutable state for the widget.
  @override
  State<SpecificWalletView> createState() => _SpecificWalletViewState();
}

// The mutable state for the SpecificWalletView widget.
class _SpecificWalletViewState extends State<SpecificWalletView> {
  // Controllers and models for managing wallet-related data.
  final WalletPageController _controller = WalletPageController();
  final BalancePageController _controllerBalance = BalancePageController();
  final ExpensePageModel _expenseModel = ExpensePageModel();
  final IncomesPageModel _incomesModel = IncomesPageModel();

  // Lifecycle method: initState is called when the widget is inserted into the tree.
  @override
  void initState() {
    super.initState();
    // Call the method to load data for the current week when the widget is initialized.
    loadWeekData();
  }

  // Method to load and calculate expenses and incomes for the current week.
  Future<void> loadWeekData() async {
    // Obtain the start and end dates for the current week.
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    // Load and calculate expenses for the current week.
    List<Expense> expenses = await _expenseModel.loadDBData();
    num expenseSum = expenses
        .where((expense) =>
    expense.creationDate.isAfter(startOfWeek) &&
        expense.creationDate.isBefore(endOfWeek) &&
        expense.walletId == widget.walletId)
        .fold(0, (prev, expense) => prev + expense.amount);

    // Load and calculate incomes for the current week.
    List<Income> incomes = await _incomesModel.loadDBData();
    num incomeSum = incomes
        .where((income) =>
    income.creationDate.isAfter(startOfWeek) &&
        income.creationDate.isBefore(endOfWeek) &&
        income.walletId == widget.walletId)
        .fold(0, (prev, income) => prev + income.amount);

    // Update the state with the calculated expense and income totals.
    setState(() {
      expenseTotal = expenseSum;
      incomeTotal = incomeSum;
    });
  }

  // Properties to store the total expenses and incomes for the current week.
  num expenseTotal = 0;
  num incomeTotal = 0;

  // Build method to create the widget tree.
  @override
  Widget build(BuildContext context) {
    // Calculate the balance by subtracting total expenses from total incomes.
    num balance = incomeTotal - expenseTotal;
    // Update the balance property of the widget.
    widget.balance.amount = balance.toString();

    // Scaffold widget represents the basic structure of the visual interface.
    return Scaffold(
      // AppBar at the top of the screen.
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: const Color(0xFF575093),
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // FlexibleSpaceBar contains the title and balance information.
            FlexibleSpaceBar(
              title: Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 80),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  balance.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        // Leading icon button to navigate back to the balance page.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _controller.gotoPage(const BalancePageView(title: "My Balance"), context);
          },
        ),
        // Action icons for additional options (e.g., delete wallet).
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            iconSize: 30,
            onPressed: () {
              _controllerBalance.dellBalance(widget.walletId);
              _controller.gotoPage(const BalancePageView(title: "My Balance"), context);
            },
          ),
        ],
      ),
      // Body of the screen containing information about expenses and incomes.
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              "This week",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            // Row containing widgets for expenses and incomes.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 20),
                // Widget for displaying and navigating to expenses page.
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      _controller.gotoPage(
                        ExpensesPageView(title: widget.title, balance: widget.balance, walletId: widget.walletId),
                        context,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFC27C9C),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Expense',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                expenseTotal.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Widget for displaying and navigating to incomes page.
                Expanded(
                  flex: 3,
                  child: GestureDetector(
                    onTap: () {
                      _controller.gotoPage(
                        IncomesPageView(title: widget.title, balance: widget.balance, walletId: widget.walletId),
                        context,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF62CB99),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Income',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                incomeTotal.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ),
      // Bottom navigation bar widget.
      bottomNavigationBar: BottomNavigationBarWidgetView(),
    );
  }
}
