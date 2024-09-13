/*
===========================================================================
  Author: xkulin01
  Description: Controller for the main page
===========================================================================
*/
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itu_dev/Views/DebtPageView.dart';
import 'package:itu_dev/Views/GoalsPageView.dart';
import 'package:itu_dev/Views/BalancePageView.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class MainPageController extends ControllerMVC {
  factory MainPageController() {
    if (_this == null) _this = MainPageController._();
    return _this;
  }

  static MainPageController _this = MainPageController._();

  MainPageController._();

  // Use for navigating from the main page to other pages
  void gotoPage(pageObj, context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pageObj),
    );
  }

  // Draw the debt section on the main page
  GestureDetector getDebtPartMain(
      hightBubble,
      wightBubble,
      color,
      controllerDebt,
      context,
      ) {
    return GestureDetector(
      onTap: () {
        controllerDebt.gotoPage(
          const DebtPageView(title: "My Debt"),
          context,
        );
      },
      child: Container(
        height: hightBubble,
        width: wightBubble,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              'My Debts',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Expanded(
              child: FutureBuilder<Column?>(
                future: controllerDebt.drawDebtForMain(0),
                builder: (context, AsyncSnapshot<Column?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return ListView(
                      children: [snapshot.data!],
                    );
                  } else {
                    return const Center(
                      child: Text('No data available'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Draw the goal section on the main page
  GestureDetector getGoalPartMain(
      hightBubble,
      wightBubble,
      color,
      controllerGoal,
      context,
      ) {
    return GestureDetector(
      onTap: () {
        controllerGoal.gotoPage(
          const GoalsPageView(title: "My Goals"),
          context,
        );
      },
      child: Container(
        height: hightBubble,
        width: wightBubble,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              'My Goals',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Expanded(
              child: FutureBuilder<Column?>(
                future: controllerGoal.drawGoalsForMain(0),
                builder: (context, AsyncSnapshot<Column?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return ListView(
                      children: [snapshot.data!],
                    );
                  } else {
                    return const Center(
                      child: Text('No data available'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Draw the balance section on the main page
  GestureDetector getBalancePartMain(
      hightBubble,
      wightBubble,
      color,
      controllerBalance,
      context,
      ) {
    return GestureDetector(
      onTap: () {
        controllerBalance.gotoPage(
          const BalancePageView(title: "My Balance"),
          context,
        );
      },
      child: Container(
        height: hightBubble,
        width: wightBubble,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              'My Wallets',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            Expanded(
              child: FutureBuilder<Column?>(
                future: controllerBalance.drawBalanceForMain(),
                builder: (context, AsyncSnapshot<Column?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return ListView(
                      children: [snapshot.data!],
                    );
                  } else {
                    return const Center(
                      child: Text('No data available'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Draw the total section on the main page
  GestureDetector getTotalPartMain(
      hightBubble,
      wightBubble,
      controllerExpense,
      controllerIncome,
      ) {
    return GestureDetector(
      onTap: () {},
      child: FutureBuilder<List<num>>(
        future: Future.wait([
          controllerExpense.calculateTotalExpenses(),
          controllerIncome.calculateTotalIncomes(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final List<num> amounts = snapshot.data ?? [0, 0];
          final expensesAmount = amounts[0];
          final incomesAmount = amounts[1];
          final colore = incomesAmount - expensesAmount >= 0
              ? Colors.green
              : Colors.red;

          // Get the current date for displaying month and year
          DateTime currentDate = DateTime.now();
          String monthYear =
              "${getMonthName(currentDate.month)} ${currentDate.year}";

          return Container(
            height: hightBubble,
            width: wightBubble,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'My Total',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                Text(
                  '($monthYear)',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 93, 93, 93),
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Income: $incomesAmount \$',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Expenses: $expensesAmount \$',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Total: ${incomesAmount - expensesAmount} \$',
                  style: TextStyle(
                    fontSize: 20,
                    color: colore,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Get the month name based on the month number
  String getMonthName(int month) {
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return monthNames[month - 1];
  }

  // Method to draw a chart for the main page (layout, not connected to a real database)
  Container drawChartForMain(
      hightBubble,
      wightBubble,
      controllerExpense,
      controllerIncome,
      ) {
    return Container(
      height: hightBubble * 1.2,
      width: wightBubble,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Balance - Last 7 days',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<num>>(
              future: controllerExpense.calculateTotalExpensesPerDay(),
              builder: (context, expenseSnapshot) {
                if (expenseSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator());
                } else if (expenseSnapshot.hasError) {
                  return Text('Error: ${expenseSnapshot.error}');
                } else if (!expenseSnapshot.hasData ||
                    expenseSnapshot.data!.length != 7) {
                  return const Center(
                    child: Text('Invalid expense data format'),
                  );
                } else {
                  final List<int> expensesData =
                  expenseSnapshot.data!.map((num value) => value.toInt()).toList();

                  return FutureBuilder<List<num>>(
                    future: controllerIncome.calculateTotalIncomesPerDay(),
                    builder: (context, incomeSnapshot) {
                      if (incomeSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      } else if (incomeSnapshot.hasError) {
                        return Text('Error: ${incomeSnapshot.error}');
                      } else if (!incomeSnapshot.hasData ||
                          incomeSnapshot.data!.length != 7) {
                        return const Center(
                          child: Text('Invalid income data format'),
                        );
                      } else {
                        final List<int> incomesData =
                        incomeSnapshot.data!.map((num value) => value.toInt()).toList();

                        final List<String> dates = List.generate(7, (index) {
                          final now = DateTime.now().subtract(
                              Duration(days: index));
                          return "${now.day}/${now.month}";
                        });

                        final double maxYValue = (expensesData + incomesData)
                            .reduce((value, element) =>
                        value > element ? value : element)
                            .toDouble();

                        return BarChart(
                          BarChartData(
                            barGroups: List.generate(7, (index) {
                              return BarChartGroupData(
                                x: index,
                                barsSpace: 4,
                                barRods: [
                                  BarChartRodData(
                                    y: expensesData[index].toDouble(),
                                    colors: [Colors.red],
                                  ),
                                  BarChartRodData(
                                    y: incomesData[index].toDouble(),
                                    colors: [Colors.green],
                                  ),
                                ],
                              );
                            }).reversed.toList(), // Reverse the order of bars
                            alignment: BarChartAlignment.spaceBetween,
                            titlesData: FlTitlesData(
                              show: true,
                              topTitles: SideTitles(showTitles: false),
                              bottomTitles: SideTitles(
                                showTitles: true,
                                getTextStyles: (context, value) =>
                                const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                ),
                                getTitles: (double value) {
                                  return dates[value.toInt()];
                                },
                                margin: 0,
                              ),
                            ),
                            borderData: FlBorderData(
                              show: true,
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            gridData: FlGridData(
                              show: false,
                            ),
                            groupsSpace: 10,
                            maxY: maxYValue + 10,
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
