/*
===========================================================================
  Author: xkulin01
  Description: Controller for Bottom navigate bar
===========================================================================
*/
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
class BottomNavigationBarWidgetController extends ControllerMVC{

  factory BottomNavigationBarWidgetController(){
    if(_this == null) _this = BottomNavigationBarWidgetController._();
    return _this;
  }

  static BottomNavigationBarWidgetController _this = BottomNavigationBarWidgetController._();
  BottomNavigationBarWidgetController._();

  //use for go to the pag
  void changePage(pageObj, context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pageObj),
    );
  }

}