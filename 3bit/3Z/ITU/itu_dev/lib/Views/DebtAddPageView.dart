/*
===========================================================================
  Author: xkulin01
  Description: View for adding a new debt
===========================================================================
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itu_dev/Views/DebtPageView.dart';
import 'package:itu_dev/Controllers/DebtPageController.dart';

class DebtAddPageView extends StatefulWidget {
  const DebtAddPageView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DebtAddPageView> createState() => _DebtAddPageViewState();
}

class _DebtAddPageViewState extends State<DebtAddPageView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final DebtPageController _controller = DebtPageController();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = "";
    String amount = "";

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text(widget.title, style: const TextStyle(fontSize: 28, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _controller.gotoPage(const DebtPageView(title: "My Debt"), context);
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 20)),
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _amountController.text.isNotEmpty &&
                  _dateController.text.isNotEmpty) {
                _controller.save(
                  _nameController.text,
                  DateFormat('yyyy-MM-dd').format(_selectedDate),
                  _amountController.text,
                );
                _controller.gotoPage(const DebtPageView(title: "My Debt"), context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill in all fields.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _nameController,
                onEditingComplete: () {
                  // This callback is triggered when the user submits the editing session
                  // Perform any additional validation logic here if needed
                },
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
                  border: OutlineInputBorder(),

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                  ),
                  labelText: 'Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onEditingComplete: () {
                  // This callback is triggered when the user submits the editing session
                  // Perform any additional validation logic here if needed
                },
                decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
                    border: OutlineInputBorder(),

                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                    ),
                  labelText: 'Amount',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: _dateController,
                    style: const TextStyle(color: Colors.white),
                    onEditingComplete: () {
                      // This callback is triggered when the user submits the editing session
                      // Perform any additional validation logic here if needed
                    },
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
                      border: OutlineInputBorder(),

                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(100, 255, 255, 255)),
                      ),
                      labelText: 'Date for pay off',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

