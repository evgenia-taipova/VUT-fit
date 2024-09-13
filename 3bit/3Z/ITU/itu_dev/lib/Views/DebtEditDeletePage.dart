/*
===========================================================================
  Author: xkulin01
  Description: View for editing or deleting a debt
===========================================================================
*/

import 'package:flutter/material.dart';
import 'package:itu_dev/Controllers/DebtPageController.dart';
import 'package:itu_dev/Views/DebtEditPageView.dart';
import 'package:itu_dev/Views/DebtPageView.dart';

class DebtEditDeletePage extends StatefulWidget {
  const DebtEditDeletePage({super.key, required this.id, required this.name, required this.amount, required this.date});

  final id;
  final name;
  final amount;
  final date;

  @override
  State<DebtEditDeletePage> createState() => _DebtEditDeletePageState();
}

class _DebtEditDeletePageState extends State<DebtEditDeletePage> {
  final DebtPageController _controller = DebtPageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 120,
          title: const Text("Your Debts", style: const TextStyle(fontSize: 28, color: Colors.white)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: (){_controller.gotoPage(const DebtPageView(title: "My Debt"), context);},
          ),
        ),
        body: Center(
            child: Column(
              children: [
                // Container displaying debt details
                Container(
                  height: 101.0,
                  width: 372.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                widget.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                widget.amount,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Text(
                            "Pay off the debt before: \n${widget.date}",
                            style: const TextStyle(
                              color: Color.fromARGB(150, 78, 77, 77),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Row with options to edit or delete the debt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Edit button
                    GestureDetector(
                      onTap: (){
                        _controller.gotoPage(DebtEditPageView(id: widget.id, name: widget.name, amount:widget.amount, date: widget.date), context);
                      },
                      child: Container(
                        height: 45.0,
                        width: 164.0,
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
                    const SizedBox(width: 16.0),
                    // Delete button
                    GestureDetector(
                      onTap: (){
                        _controller.dellDebt(widget.id);
                        _controller.gotoPage(const DebtPageView(title: "My Debt"), context);
                      },
                      child: Container(
                        height: 45.0,
                        width: 164.0,
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
                    )
                  ],
                )
              ],
            )
        )
    );
  }
}
