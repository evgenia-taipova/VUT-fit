/*
=========================================================================================================
File: IncomeDetailsPageView.dart
Author: Dinara Garipova (xgarip00)

This Dart file defines a StatelessWidget class, IncomeDetailsPageView, representing a page that displays
details for a specific income. It includes income information, deposit and withdraw buttons, as well as
edit and delete buttons. The class uses the IncomesPageController for navigation and data management.
==========================================================================================================
*/
import 'package:flutter/material.dart';
import 'package:itu_dev/Models/BalancePageModel.dart';
import 'package:itu_dev/Views/EditIncomePageView.dart';
import '../Controllers/IncomesPageController.dart';
import '../Models/IncomesPageModel.dart';
import 'DepositIncomePageView.dart';
import 'IncomesPageView.dart';
import 'WithdrawIncomePageView.dart';

class IncomeDetailsPageView extends StatelessWidget {
  final Income income;
  final Balance balance;
  final int walletId;
  final String title;

  // Constructor for the IncomeDetailsPageView.
  IncomeDetailsPageView({
    Key? key,
    required this.income,
    required this.walletId,
    required this.balance,
    required this.title,
  }) : super(key: key);

  // Controller for managing navigation and data related to incomes.
  final IncomesPageController _controller = IncomesPageController();

  @override
  Widget build(BuildContext context) {
    // Define button styles for consistent appearance.
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
      appBar: AppBar(
        title: const Text(
          'Income',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF575093),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _controller.gotoPage(
              IncomesPageView(title: title, walletId: walletId, balance: balance),
              context,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: const Alignment(0.0, -0.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Display card with income details, including name and amount.
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Color(income.color),
                ),
                height: 80.0,
                child: ListTile(
                  contentPadding: const EdgeInsets.only(left: 25.0, right: 22.0, top: 15.0),
                  title: Text(
                    income.name,
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                  trailing: Text(
                    income.amount.toString(),
                    style: const TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                ),
              ),
              // Button bar for deposit and withdraw actions.
              ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () {
                      _controller.gotoPage(
                        DepositIncomePageView(
                          income: income,
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
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () {
                      _controller.gotoPage(
                        WithdrawIncomePageView(
                          income: income,
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
              // Button bar for edit and delete actions.
              ButtonBar(
                alignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    style: buttonStyle,
                    onPressed: () {
                      _controller.gotoPage(
                        EditIncomePageView(
                          income: income,
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
                  ElevatedButton(
                    style: deleteButtonStyle,
                    onPressed: () {
                      _controller.dellIncome(income.id);

                      _controller.gotoPage(
                        IncomesPageView(
                          title: title,
                          balance: balance,
                          walletId: walletId,
                        ),
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
