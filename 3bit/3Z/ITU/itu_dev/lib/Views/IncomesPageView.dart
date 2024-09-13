/*
=========================================================================================================
File: IncomesPageView.dart
Author: Dinara Garipova (xgarip00)

This Dart file defines a StatefulWidget class, IncomesPageView, representing a page that displays a list of
incomes. It includes an app bar with navigation and action buttons, a list of income items, and a
bottom navigation bar. The class utilizes the IncomesPageController for navigation and the IncomesPageModel
for managing income-related data.
==========================================================================================================
*/
import 'package:flutter/material.dart';
import 'package:itu_dev/Controllers/IncomesPageController.dart';
import 'package:itu_dev/Models/BalancePageModel.dart';
import 'package:itu_dev/Views/BottomNavigationBarWidgetView.dart';
import 'package:itu_dev/Views/NewIncomePageView.dart';
import 'package:itu_dev/Views/SpecificWalletView.dart';
import 'package:itu_dev/Views/income_item_widget.dart';
import '../Models/IncomesPageModel.dart';
import 'IncomeDetailPageView.dart';

class IncomesPageView extends StatefulWidget {
  const IncomesPageView({
    Key? key,
    required this.title,
    required this.walletId,
    required this.balance,
  }) : super(key: key);

  final String title;
  final int walletId;
  final Balance balance;

  @override
  State<IncomesPageView> createState() => _IncomesPageViewState();
}

class _IncomesPageViewState extends State<IncomesPageView> {
  // Controller for managing navigation and data related to incomes.
  final IncomesPageController _controller = IncomesPageController();

  // Model for managing data related to incomes.
  final IncomesPageModel _incomeModel = IncomesPageModel();

  // List to store loaded incomes.
  List<Income> _incomes = [];

  @override
  void initState() {
    super.initState();
    loadIncomes();
  }

  // Method to refresh the view when triggered
  Future<void> _refresh() async {
    setState(() {});
  }

  // Method to load incomes from the database
  Future<void> loadIncomes() async {
    List<Income> allIncomes = await _incomeModel.loadDBData();
    setState(() {
      _incomes = allIncomes.where((income) => income.walletId == widget.walletId).toList();
    });
  }

  // Method to navigate to the New Income page
  void navigateToNewIncomePage() {
    _controller.gotoPage(
      NewIncomePageView(
        title: widget.title,
        balance: widget.balance,
        walletId: widget.walletId,
      ),
      context,
    );
  }

  // Method to build the app bar for the Incomes page
  AppBar buildAppBar() {
    return AppBar(
      toolbarHeight: 120,
      backgroundColor: const Color(0xFF575093),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          _controller.gotoPage(
            SpecificWalletView(
              title: widget.title,
              balance: widget.balance,
              walletId: widget.walletId,
            ),
            context,
          );
        },
      ),
      title: const Text(
        "Incomes",
        style: TextStyle(
          fontSize: 32,
          color: Colors.white,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.add, color: Colors.white),
          onPressed: navigateToNewIncomePage,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          itemCount: _incomes.length,
          itemBuilder: (context, index) {
            final income = _incomes[index];
            return InkWell(
              onTap: () {
                _controller.gotoPage(
                  IncomeDetailsPageView(
                    income: income,
                    balance: widget.balance,
                    walletId: widget.walletId,
                    title: widget.title,
                  ),
                  context,
                );
              },
              child: IncomeItemWidget(
                color: income.color,
                name: income.name,
                amount: income.amount,
                icon: income.icon.codePoint,
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidgetView(),
    );
  }
}
