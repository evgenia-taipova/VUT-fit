/*
===========================================================================
  Author: xkulin01
  Description: View for editing a debt, allowing the user to modify debt details and save changes
===========================================================================
*/

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itu_dev/Views/DebtPageView.dart';
import 'package:itu_dev/Views/DebtEditDeletePage.dart';
import 'package:itu_dev/Controllers/DebtPageController.dart';

class DebtEditPageView extends StatefulWidget {
  const DebtEditPageView({
    super.key,
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
  });

  final id;
  final name;
  final amount;
  final date;

  @override
  State<DebtEditPageView> createState() => _DebtEditPageViewState();
}

class _DebtEditPageViewState extends State<DebtEditPageView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  final DebtPageController _controller = DebtPageController();
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
    _amountController.text = widget.amount;
    _dateController.text = widget.date;
    _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.date);
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: const Text("Edit", style: TextStyle(fontSize: 28, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            _controller.gotoPage(
              DebtEditDeletePage(
                id: widget.id,
                name: widget.name,
                amount: widget.amount,
                date: widget.date,
              ),
              context,
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Save', style: TextStyle(color: Colors.white, fontSize: 20)),
            onPressed: () {
              String newName = _nameController.text;
              String newAmount = _amountController.text;
              String newDate = _dateController.text;

              if (newName.isNotEmpty && newAmount.isNotEmpty && newDate.isNotEmpty) {
                _controller.edit(widget.id, newName, newDate, newAmount);
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
                onChanged: (text) {
                  // You can perform any additional logic on text change if needed
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
                onChanged: (text) {
                  // You can perform any additional logic on text change if needed
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

