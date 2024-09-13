/*
=========================================================================================================
File: EditIncomePageView.dart
Author: Dinara Garipova (xgarip00)

This Dart file defines a StatefulWidget class, EditIncomePageView, representing the page for editing income details.
Users can edit the name, amount, color, and icon of the income.
==========================================================================================================
*/
import 'package:flutter/material.dart';
import 'package:itu_dev/Controllers/IncomesPageController.dart';
import 'package:itu_dev/Models/BalancePageModel.dart';
import 'package:itu_dev/Models/IncomesPageModel.dart';

import 'IncomesPageView.dart';

// StatefulWidget for editing income details.
class EditIncomePageView extends StatefulWidget {
  // Properties to hold income details, wallet information, and page title.
  final Income income;
  final int walletId;
  final Balance balance;
  final String title;

  // Constructor to initialize the properties when creating an instance of the class.
  const EditIncomePageView({Key? key, required this.income, required this.walletId, required this.balance, required this.title})
      : super(key: key);

  @override
  State<EditIncomePageView> createState() => _EditIncomePageViewState();
}

// State class for the EditIncomePageView.
class _EditIncomePageViewState extends State<EditIncomePageView> {
  // Instance of IncomesPageController for handling page navigation and actions.
  final IncomesPageController _controller = IncomesPageController();

  // Text controllers for the name and amount input fields.
  late TextEditingController nameController;
  late TextEditingController amountController;

  // Variables to hold the selected color and icon for the income.
  int selectedColor = 0xFFDBB387;
  IconData selectedIcon =
  const IconData(0xe59c, fontFamily: 'MaterialIcons');

  @override
  void initState() {
    super.initState();

    // Initialize text controllers with the income details.
    nameController = TextEditingController(text: widget.income.name);
    amountController = TextEditingController(text: widget.income.amount.toString());

    // Initialize selected color and icon with the income details.
    selectedColor = widget.income.color;
    selectedIcon = IconData(widget.income.icon.codePoint, fontFamily: 'MaterialIcons');
  }

  // Function to display an error snackbar.
  Future<void> _showErrorSnackBar(String message) async {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Function to choose a color from a dialog.
  Future<void> chooseColor() async {
    int? pickedColor = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Color'),
          content: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(0xFFDBB387);
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFDBB387),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(0xFF44C7BB);
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF44C7BB),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(0xFF6F73D2);
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF6F73D2),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (pickedColor != null) {
      setState(() {
        selectedColor = pickedColor;
      });
    }
  }

  // Function to choose an icon from a dialog.
  Future<void> chooseIcon() async {
    IconData? pickedIcon = await showDialog<IconData>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Icon'),
          content: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pop(const IconData(0xf05d6, fontFamily: 'MaterialIcons'));
                },
                child: const Icon(IconData(0xf05d6, fontFamily: 'MaterialIcons'),
                    size: 36),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pop(const IconData(0xe0b2, fontFamily: 'MaterialIcons'));
                },
                child: const Icon(IconData(0xe0b2, fontFamily: 'MaterialIcons'),
                    size: 36),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pop(const IconData(0xf1dd, fontFamily: 'MaterialIcons'));
                },
                child: const Icon(IconData(0xf1dd, fontFamily: 'MaterialIcons'),
                    size: 36),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pop(const IconData(0xf4d5, fontFamily: 'MaterialIcons'));
                },
                child: const Icon(IconData(0xf4d5, fontFamily: 'MaterialIcons'),
                    size: 36),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pop(const IconData(0xe59f, fontFamily: 'MaterialIcons', matchTextDirection: true));
                },
                child: const Icon(IconData(0xe59f, fontFamily: 'MaterialIcons', matchTextDirection: true),
                    size: 36),
              ),
            ],
          ),
        );
      },
    );

    if (pickedIcon != null) {
      setState(() {
        selectedIcon = pickedIcon;
      });
    }
  }

  // Build method to create the UI for editing an income.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF575093),
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            'Edit Income',
            style: TextStyle(fontSize: 28, color: Colors.white),
          ),
        ),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              _controller.gotoPage(IncomesPageView(title: widget.title, walletId: widget.walletId, balance: widget.balance),context);
            },
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 17.0),
            child: TextButton(
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                if (nameController.text.isEmpty || amountController.text.isEmpty) {
                  _showErrorSnackBar('Please fill in both name and amount.');
                } else {
                  // Edit the income with the new details.
                  _controller.edit(
                    widget.income.id,
                    nameController.text,
                    num.parse(amountController.text),
                    selectedColor,
                    selectedIcon,
                  );
                  // Navigate to the IncomesPageView with updated data.
                  _controller.gotoPage(
                      IncomesPageView(title: "Incomes", balance: widget.balance, walletId: widget.walletId,), context);
                }
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Input field for the income name.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            // Input field for the income amount.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: amountController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            // Row for selecting the income color.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    'Select Color: ',
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: chooseColor,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(selectedColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Row for selecting the income icon.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text(
                    'Select Icon: ',
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: chooseIcon,
                    child: Icon(selectedIcon, size: 30, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
