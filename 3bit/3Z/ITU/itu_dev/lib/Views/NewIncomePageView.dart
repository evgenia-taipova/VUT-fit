/*
=========================================================================================================
File: NewIncomePageView.dart
Author: Dinara Garipova (xgarip00)

This Dart file defines a StatefulWidget class, NewIncomePageView, representing a page for adding a new income.
It includes text input fields for the income name and amount, as well as options to choose color and icon.
The class utilizes the IncomesPageController and BalancePageController for managing income-related data and
updating the balance.
==========================================================================================================
*/
import 'package:flutter/material.dart';
import 'package:itu_dev/Models/BalancePageModel.dart';
import 'package:itu_dev/Views/IncomesPageView.dart';
import 'package:itu_dev/Controllers/IncomesPageController.dart';
import 'package:itu_dev/Controllers/BalancePageController.dart';
class NewIncomePageView extends StatefulWidget {
  // Constructor for the NewIncomePageView widget.
  const NewIncomePageView({Key? key, required this.title, required this.walletId, required this.balance}) : super(key: key);

  final String title;
  final int walletId;
  final Balance balance;

  @override
  State<NewIncomePageView> createState() => _NewIncomePageViewState();
}

class _NewIncomePageViewState extends State<NewIncomePageView> {
  // Controllers for managing incomes and balance data.
  final IncomesPageController _controller = IncomesPageController();
  final BalancePageController _controllerBalance = BalancePageController();
  // Variables to store user inputs.
  String categoryName = "";
  String amount = "";
  int selectedColor = 0xFFDBB387;
  IconData selectedIcon = const IconData(0xf4d5, fontFamily: 'MaterialIcons');

  // Method to show an error Snackbar.
  Future<void> _showErrorSnackBar(String message) async {
    final snackBar = SnackBar(
      content: Text(
          message),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  // Method to show a dialog for choosing a color.
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
  // Method to show a dialog for choosing an icon.
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
                      .pop(
                      const IconData(0xf05d6, fontFamily: 'MaterialIcons'));
                },
                child: const Icon(
                    IconData(0xf05d6, fontFamily: 'MaterialIcons'),
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
                      .pop(const IconData(0xe59f, fontFamily: 'MaterialIcons',
                      matchTextDirection: true));
                },
                child: const Icon(IconData(0xe59f, fontFamily: 'MaterialIcons',
                    matchTextDirection: true),
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

  @override
  Widget build(BuildContext context) {
    // Scaffold is a basic material design visual structure.
    return Scaffold(
      appBar: AppBar(
        // Customizing the app bar appearance.
        backgroundColor: const Color(0xFF575093),
        elevation: 0,
        title: const Padding(
          // Adding padding to the title for visual aesthetics.
          padding: EdgeInsets.only(top: 20.0),
          child: Text(
            "New Income",
            style: TextStyle(fontSize: 28, color: Colors.white),
          ),
        ),
        centerTitle: true,
        leading: Padding(
          // Adding padding to the leading (back) button for visual aesthetics.
          padding: const EdgeInsets.only(top: 20.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // Navigating back to the IncomesPageView when the back button is pressed.
              _controller.gotoPage(
                IncomesPageView(
                  title: widget.title,
                  walletId: widget.walletId,
                  balance: widget.balance,
                ),
                context,
              );
            },
          ),
        ),
        actions: <Widget>[
          // Adding a "Save" button to the app bar.
          Padding(
            padding: const EdgeInsets.only(top: 17.0),
            child: TextButton(
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () {
                // Handling the save button press.
                if (categoryName.isEmpty || amount.isEmpty) {
                  // Showing an error snackbar if either the name or amount is not filled.
                  _showErrorSnackBar('Please fill in both name and amount.');
                } else {
                  // Saving the income details and updating the balance.
                  DateTime currentDate = DateTime.now();
                  _controller.save(
                    widget.walletId,
                    categoryName,
                    num.parse(amount),
                    selectedColor,
                    selectedIcon,
                    currentDate,
                  );
                  _controllerBalance.getActualAmount(widget.walletId).then((
                      actualAmount) {
                    if (actualAmount != null) {
                      // Adjusting the balance by adding the income amount.
                      _controllerBalance.edit(
                        widget.walletId,
                        widget.balance.name,
                        actualAmount + num.parse(amount),
                      );
                    }
                  });
                  // Navigating back to the IncomesPageView after saving.
                  _controller.gotoPage(
                    IncomesPageView(
                      title: "Incomes",
                      balance: widget.balance,
                      walletId: widget.walletId,
                    ),
                    context,
                  );
                }
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        // Allowing scrolling to accommodate various screen sizes.
        child: Column(
          children: [
            // Text input for the income name.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (text) {
                  // Updating the categoryName variable when the text changes.
                  setState(() {
                    categoryName = text;
                  });
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                      color: Color.fromARGB(100, 255, 255, 255)),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(100, 255, 255, 255)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(100, 255, 255, 255)),
                  ),
                ),
              ),
            ),
            // Text input for the income amount.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onChanged: (text) {
                  // Updating the amount variable when the text changes.
                  setState(() {
                    amount = text;
                  });
                },
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  labelStyle: TextStyle(
                      color: Color.fromARGB(100, 255, 255, 255)),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(100, 255, 255, 255)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(100, 255, 255, 255)),
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
