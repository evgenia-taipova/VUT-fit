/*
=========================================================================================================
File: ExpensesPageView.dart
Author: Dinara Garipova (xgarip00)

This Dart file defines a StatefulWidget class, ExpensesPageView, representing the Expenses page in the app.
It includes methods to load and display expenses, a pull-to-refresh functionality, and navigation to
other views such as NewExpensePageView and ExpenseDetailsPageView.
==========================================================================================================
*/
import 'package:flutter/material.dart';
import 'package:itu_dev/Controllers/ExpensesPageController.dart';
import 'package:itu_dev/Models/BalancePageModel.dart';
import 'package:itu_dev/Views/BottomNavigationBarWidgetView.dart';
import 'package:itu_dev/Views/NewExpensePageView.dart';
import 'package:itu_dev/Views/SpecificWalletView.dart';
import 'package:itu_dev/Views/expense_item_widget.dart';
import '../Models/ExpensesPageModel.dart';
import 'ExpenseDetailPageView.dart';

// StatefulWidget representing the Expenses page in the app.
class ExpensesPageView extends StatefulWidget {
  const ExpensesPageView({Key? key, required this.title, required this.walletId, required this.balance}) : super(key: key);

  final String title;
  final int walletId;
  final Balance balance;

  @override
  State<ExpensesPageView> createState() => _ExpensesPageViewState();
}

class _ExpensesPageViewState extends State<ExpensesPageView> {
  // Instance of ExpensesPageController for handling navigation.
  final ExpensesPageController _controller = ExpensesPageController();
  // Instance of ExpensePageModel to interact with expense data.
  final ExpensePageModel _expenseModel = ExpensePageModel();
  // List to store the loaded expenses.
  List<Expense> _expenses = [];

  // Method to refresh the view when triggered
  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Load expenses when the page is initialized.
    loadExpenses();
  }

  // Method to load expenses from the database.
  Future<void> loadExpenses() async {
    List<Expense> allExpenses = await _expenseModel.loadDBData();
    setState(() {
      // Filter expenses based on the walletId.
      _expenses = allExpenses.where((expense) => expense.walletId == widget.walletId).toList();
    });
  }

  // Method to navigate to the NewExpensePageView.
  void navigateToNewExpensePage() {
    _controller.gotoPage(
      NewExpensePageView(title: widget.title, balance: widget.balance, walletId: widget.walletId),
      context,
    );
  }

  // Method to build the app bar for the Expenses page.
  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 120,
      backgroundColor: const Color(0xFF575093),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          _controller.gotoPage(SpecificWalletView(title: widget.title, balance: widget.balance, walletId: widget.walletId),context);
        },
      ),
      title: const Text(
        "Expenses",
        style: TextStyle(
          fontSize: 32,
          color: Colors.white,
        ),
      ),
      centerTitle: false,
      actions: [
        // IconButton to navigate to the NewExpensePageView.
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: navigateToNewExpensePage,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      // Body with a RefreshIndicator for pull-to-refresh functionality.
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: _expenses.length,
          itemBuilder: (context, index) {
            // Build each expense item as an InkWell for tapping.
            final expense = _expenses[index];
            return InkWell(
              onTap: () {
                // Navigate to ExpenseDetailsPageView when an item is tapped.
                _controller.gotoPage(
                  ExpenseDetailsPageView(expense: expense, balance: widget.balance, walletId: widget.walletId, title: widget.title,),
                  context,
                );
              },
              // Use ExpenseItemWidget to display the expense information.
              child: ExpenseItemWidget(
                color: expense.color,
                name: expense.name,
                amount: expense.amount,
                icon: expense.icon.codePoint,
              ),
            );
          },
        ),
      ),
      // BottomNavigationBarWidgetView for the bottom navigation bar.
      bottomNavigationBar: BottomNavigationBarWidgetView(),
    );
  }
}
