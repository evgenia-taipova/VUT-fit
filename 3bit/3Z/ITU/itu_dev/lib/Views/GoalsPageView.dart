// File: GoalsPageView.dart
// Author: Taipova Evgeniya (xtaipo00)
// Description: This file contains the implementation of the GoalsPageView class,
// which is responsible for displaying and managing goals in the finance application.


import 'package:flutter/material.dart';
import 'package:itu_dev/Views/GoalsAddPageView.dart';
import 'package:itu_dev/Views/BottomNavigationBarWidgetView.dart';
import 'package:itu_dev/Controllers/GoalsPageController.dart';

class GoalsPageView extends StatefulWidget {
  const GoalsPageView({super.key, required this.title});

  final String title;

  @override
  State<GoalsPageView> createState() => _GoalsPageViewState();
}

class _GoalsPageViewState extends State<GoalsPageView>{
  final GoalsPageController _controller = GoalsPageController();

  Future<void> _refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text(widget.title, style: const TextStyle(fontSize: 28, color: Colors.white)),
        actions: <Widget>[
          // Add button to navigate to the GoalsAddPageView.
          IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              iconSize: 35,
              onPressed: (){
                _controller.gotoPage(const GoalsAddPageView(title: "New Goal"), context);
              }
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            width: double.infinity,
            child: FutureBuilder<Column?>(
              // Fetch and display goals using the GoalsPageController.
              future: _controller.drawBubbleGoal(context, 255),
              builder: (context, AsyncSnapshot<Column?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show loading indicator while fetching data.
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Show error message if there's an error.
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data != null) {
                  // Display the list of goals when data is available.
                  return snapshot.data!;
                } else {
                  // Display a message when no data is available.
                  return const Center(
                    child: Text('No data available'),
                  );
                }
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidgetView(), // Display the bottom navigation bar.
    );
  }
}
