/*
===========================================================================
  Author: xkulin01
  Description: Controller for debt page
===========================================================================
*/
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:itu_dev/Models/DebtPageModel.dart';
import 'package:itu_dev/Views/DebtEditDeletePage.dart';

class DebtPageController extends ControllerMVC{
  final DebtPageModel _model = DebtPageModel();
  factory DebtPageController(){
    if(_this == null) _this = DebtPageController._();
    return _this;
  }

  static DebtPageController _this = DebtPageController._();
  DebtPageController._();

  Future<Column> drawBubble(context, colorAlfa) async{
    List<Widget> widgets;
    List<Debt> debts = await _model.loadDBData();
    widgets = debts.map((debt) {
      return Column(
        children: [
          GestureDetector(
            onTap: () {
              _this.gotoPage(DebtEditDeletePage(id: debt.id, name: debt.name, amount: debt.amount, date: debt.date), context);
            },
            child: _this.drawContainerDebt(101.0,372.0, colorAlfa, debt),
          ),
          const SizedBox(height: 16.0),
        ],
      );
    }).toList();
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: widgets);
  }

  Future<Column> drawDebtForMain(colorAlfa) async{
    List<Widget> widgets;
    List<Debt> debts = await _model.loadDBData();
    widgets = debts.map((debt) {
      return Column(
        children: [
            _this.drawContainerDebt(60.0, 372.0, colorAlfa, debt),
          const SizedBox(height: 3.0),
        ],
      );
    }).toList();
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: widgets);
  }

  void gotoPage(pageObj, context){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => pageObj),
    );
  }
  
  Container drawContainerDebt(height,width, colorAlfa, debt){

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Color.fromARGB(colorAlfa, 255, 255, 255),
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
                    debt.name,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    debt.amount + "\$",
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
                "Pay off the debt before: \n${debt.date}",
                style: const TextStyle(
                  color: Color.fromARGB(150, 78, 77, 77),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void dellDebt(id){
    _model.dellDebtFromDB(id);
  }

  void save(name, date, amount){
    _model.addDebtToDb(name, date, amount);
  }

  void edit(id, newName, newDate, newAmount){
    _model.editDebtInDB(id, newName, newAmount, newDate);
  }
}