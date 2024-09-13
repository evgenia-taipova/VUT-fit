/*
===========================================================================
  Author: xkulin01
  Description: Controller for tips page
===========================================================================
*/
import 'package:mvc_pattern/mvc_pattern.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:itu_dev/Models/TipsPageModel.dart';
import 'package:itu_dev/Views/TipsTextPageView.dart';
class TipsPageController extends ControllerMVC{
  final TipsPageModel _model = TipsPageModel();
  factory TipsPageController(){
    if(_this == null) _this = TipsPageController._();
    return _this;
  }

  static TipsPageController _this = TipsPageController._();
  TipsPageController._();

  //method to get color based on category of tip
  Color getBackgroundColor(String category) {
    switch (category) {
      case 'Useful':
        return Colors.green;
      case 'Useless':
        return Colors.red;
      default:
        return Colors.white;
    }
  }

  //draw bubble of all tips which are in db
  Future<Column> drawBubble(context, chooseCategory) async{
    List<Widget> widgets;
    List<Tip> tips = await _model.loadDBData();


    if (chooseCategory != 'All') {
      tips = tips.where((tip) => tip.category == chooseCategory).toList();
    }

    widgets = tips.map((tip) {
      return Column(
        children: [
          GestureDetector(
            onTap: () async {
              _this.gotoPage(TipsTextPageView(title: tip.title, time: tip.time, text: tip.text, category: tip.category), context);
            },
            child: Container(
              height: 101.0,
              width: 372.0,
              decoration: BoxDecoration(
                color: getBackgroundColor(tip.category),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      tip.title,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      tip.time,
                      style: const TextStyle(
                        color: Color.fromARGB(150, 78, 77, 77),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
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

  //get random tip use to get notification
  Future<Tip> getRandomTip() async {
    final TipsPageModel model = TipsPageModel();
    List<Tip> tips = await model.loadDBData();

    final Random random = Random();
    int randomIndex = random.nextInt(tips.length);

    return tips[randomIndex];
  }

  //edit category of tip
  void editCategory(title, time, text, newCategory){
    _model.editTipCategory(title, time, text, newCategory);
  }
}