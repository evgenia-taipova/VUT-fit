/*
======================================================================================
File: SpecificWalletPageController.dart
Author: Dinara Garipova (xgarip00)

This Dart file defines a controller class, WalletPageController, using the MVC pattern.
It extends the ControllerMVC class from the 'mvc_pattern' package.
The controller is responsible for managing the logic related to the WalletPage view.
========================================================================================
 */
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:itu_dev/Views/SpecificWalletView.dart';
import 'package:itu_dev/Models/SpecificWalletPageModel.dart';

class WalletPageController extends ControllerMVC {

  // Factory constructor to implement a singleton pattern
  factory WalletPageController(){
    _this ??= WalletPageController();
    return _this;
  }

  // Singleton instance variable
  static WalletPageController _this = WalletPageController._();

  // Private constructor to prevent direct instantiation
  WalletPageController._();

  // Method to navigate to a specified page and replace the current page
  void gotoPage(pageObj, context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pageObj),
    );
  }
}
