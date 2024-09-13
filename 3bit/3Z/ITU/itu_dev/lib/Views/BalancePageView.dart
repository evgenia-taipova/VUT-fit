// File: BalancePageView.dart
// Author: Taipova Evgeniya (xtaipo00)
// Description: This file contains the implementation of the BalancePageView class,
// which is responsible for displaying the user's balance and allowing them to add new balances.

import 'package:flutter/material.dart';
import 'package:itu_dev/Views/BottomNavigationBarWidgetView.dart';
import '../Controllers/BalancePageController.dart';
import 'BalanceAddPageView.dart';

class BalancePageView extends StatefulWidget {
  const BalancePageView({super.key, required this.title});

  final String title;

  @override
  State<BalancePageView> createState() => _BalancePageViewState();
}


class _BalancePageViewState extends State<BalancePageView> {
  final BalancePageController _controller = BalancePageController();
  Color color = Colors.white;
  var wightBubble = 372.0;
  var heightBubble = 70.0;
  // Declare totalAmount as a late variable
  late num totalAmount;


  Future<void> _refresh() async {
    _controller.gotoPage(const BalancePageView(title: "My Balance"), context);
  }

  @override
  void initState(){
    super.initState();
    totalAmount = 0;
    // Load the totalAmount when the widget is initialized
    _controller.calculateTotalAmount().then((value) {
      setState(() {
        totalAmount = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text(widget.title, style: const TextStyle(fontSize: 28, color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            iconSize: 35,
            onPressed: () {
              _controller.gotoPage(const BalanceAddPageView(title: "New Balance"), context);
            },
          )
        ],
      ),
      body: RefreshIndicator(
      // Pull-to-refresh indicator
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Display the total balance in a container
                Container(
                  height: heightBubble,
                  width: wightBubble,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'My Total',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        // Display the totalAmount
                        Text(
                          '${totalAmount ?? 0}\$',
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Load and display additional balance data
                FutureBuilder<Widget>(
                  future: _controller.drawBubbleBalance(context, 255),
                  builder: (context, AsyncSnapshot<Widget> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData && snapshot.data != null) {
                      return snapshot.data!;
                    } else {
                      return const Center(
                        child: Text('No data available'),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidgetView(),
    );
  }
}
