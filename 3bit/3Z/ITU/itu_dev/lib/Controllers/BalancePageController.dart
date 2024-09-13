// File: BalancePageController.dart
// Author: Taipova Evgeniya (xtaipo00)
// Description: This file contains the implementation of the BalancePageController class,
// which is responsible for managing balance-related logic, including loading, adding, deleting,
// and editing balance entries.

import 'package:itu_dev/Views/SpecificWalletView.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import '../Models/BalancePageModel.dart';
import '../Models/ExpensesPageModel.dart';
import '../Models/IncomesPageModel.dart';

class BalancePageController extends ControllerMVC {
  final BalancePageModel _model = BalancePageModel();
  final ExpensePageModel _expenseModel = ExpensePageModel();
  final IncomesPageModel _incomesModel = IncomesPageModel();
  factory BalancePageController() {
    _this ??= BalancePageController._();
    return _this;
  }

  static BalancePageController _this = BalancePageController._();
  BalancePageController._();

  late num totalAmount = 0; // Declare totalAmount as a num variable

  // Create a widget for displaying balances
  Future<Widget> drawBubbleBalance(context, colorAlfa) async {
    List<Balance> balances = await _model.loadDBData();
    return Padding(
      padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 2,
        ),
        itemCount: balances.length,
        itemBuilder: (context, index)  {
          Balance balance = balances[index];
          return GestureDetector(
            onTap: () {
              _this.gotoPage(SpecificWalletView(title: balance.name, balance: balance, walletId: balance.id), context);
            },
            child: _this.drawContainerBalance(50.0, 170.0, colorAlfa, balance),
          );
        },
      ),
    );
  }

  // Calculate the total amount of balances
  Future<num> calculateTotalAmount() async {
    List<Balance> balances = await _model.loadDBData();
    num calculatedTotalAmount = balances.fold<num>(
      0,
          (num sum, Balance balance) => sum + (double.tryParse(balance.amount) ?? 0),
    );
    return calculatedTotalAmount;
  }

  //function was written by xkulin01
  Future<num?> getActualAmount(id) async {
    List<Balance> balances = await _model.loadDBData();
    Balance? targetBalance = balances.firstWhere((balance) => balance.id == id);
    return  double.tryParse(targetBalance.amount);
  }

  // Update the total amount
  Future<void> updateTotalAmount() async {
    totalAmount = await calculateTotalAmount();
    setState(() {});
  }

  //function was written by xkulin01
  Future<Column> drawBalanceForMain() async {
    List<Widget> widgets;
    List<Balance> balances = await _model.loadDBData();
    widgets = balances.map((balance) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 16.0),
              Text(
                balance.name,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const Spacer(),
              Text(
                "${balance.amount}\$",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 16.0),
            ],
          ),
          const SizedBox(height: 3.0),
        ],
      );
    }).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widgets,
    );
  }


// Navigate to another page
  void gotoPage(pageObj, context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pageObj),
    );
  }

  // Draw a container for displaying balance
  Container drawContainerBalance(height, width, colorAlfa, balance) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Color.fromARGB(colorAlfa, 255, 255, 255),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              balance.name,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center, // Center text within the container
            ),
            const SizedBox(height: 3.0),
            Text(
              "${balance.amount}\$",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Delete a balance
  void dellBalance(id) {
    _incomesModel.deleteIncomesByWalletId(id);
    _expenseModel.deleteExpensesByWalletId(id);
    _model.dellBalanceFromDB(id);
    updateTotalAmount();
  }

  // Save a new balance
  void saveBalance(name, amount) {
    _model.addBalanceToDb(name, amount).then((_) {
      updateTotalAmount(); // Update totalAmount immediately after saving
    });
  }

  // Edit a balance
  void edit(id, newName, newAmount){
    _model.editBalanceInDB(id, newName, newAmount).then((_) {
      updateTotalAmount(); // Update totalAmount immediately after editing
    });
  }
}
