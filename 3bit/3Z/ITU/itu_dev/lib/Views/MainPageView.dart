/*
===========================================================================
  Author: xkulin01
  Description: Main view displaying various financial indicators and goals.
===========================================================================
*/
import 'package:flutter/material.dart';
import 'package:itu_dev/Controllers/GoalsPageController.dart';
import 'package:itu_dev/Controllers/MainPageController.dart';
import 'package:itu_dev/Controllers/DebtPageController.dart';
import 'package:itu_dev/Controllers/BalancePageController.dart';
import 'package:itu_dev/Controllers/ExpensesPageController.dart';
import 'package:itu_dev/Controllers/IncomesPageController.dart';
import 'package:itu_dev/Views/BottomNavigationBarWidgetView.dart';
import 'package:itu_dev/Views/NotificationsPageView.dart';


class MainPageView extends StatefulWidget{
  const MainPageView({super.key, required this.title});

  final String title;
  @override
  _MainPageViewState createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView>{
  final MainPageController _controllerMain = MainPageController();
  final DebtPageController _controllerDebt = DebtPageController();
  final GoalsPageController _controllerGoal = GoalsPageController();
  final BalancePageController _controllerBalance = BalancePageController();
  final ExpensesPageController _controllerExpense = ExpensesPageController();
  final IncomesPageController _controllerIncomes = IncomesPageController();

  @override
  Widget build(BuildContext context) {
    // Configuration for the appearance of the financial indicator bubbles
    Color color = Colors.white;
    var wightBubble = 372.0;
    var hightBubble = 171.0;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text(widget.title, style: const TextStyle(fontSize: 28, color: Colors.white)),
        actions: <Widget>[
          // Button to navigate to the notifications page
          IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              iconSize: 35,
              onPressed: (){
                _controllerMain.gotoPage(const NotificationsPageView(title: "My Notifications"), context);
              }
          )
        ],
      ),
      body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _controllerMain.getTotalPartMain(hightBubble, wightBubble, _controllerExpense, _controllerIncomes),
                const SizedBox(height: 7),
                _controllerMain.getBalancePartMain(hightBubble, wightBubble, color, _controllerBalance, context),
                const SizedBox(height: 7),
                _controllerMain.drawChartForMain(hightBubble, wightBubble, _controllerExpense, _controllerIncomes),
                // Container(
                //   height: hightBubble,
                //   width: wightBubble,
                //   decoration: BoxDecoration(
                //     color: color,
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   child: const Center(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: <Widget>[
                //         Text(
                //           'Balance - Last 7 days',
                //           style: TextStyle(
                //             fontSize: 24,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 7),
                _controllerMain.getGoalPartMain(hightBubble, wightBubble, color, _controllerGoal, context),
                const SizedBox(height: 7),
                _controllerMain.getDebtPartMain(hightBubble, wightBubble, color, _controllerDebt, context),
                const SizedBox(height: 7),
              ],
            ),
          )
      ),
      bottomNavigationBar: BottomNavigationBarWidgetView(),
    );
  }
}