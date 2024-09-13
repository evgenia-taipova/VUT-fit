/*
===========================================================================
  Author: xkulin01
  Description: Controller for notification page
===========================================================================
*/

import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:itu_dev/Models/NotificationPageModel.dart' as CustomNotification;
import 'package:itu_dev/Views/TipsPageView.dart';

class NotificationPageController extends ControllerMVC{
  final CustomNotification.NotificationPageModel _model = CustomNotification.NotificationPageModel();
  factory NotificationPageController(){
    if(_this == null) _this = NotificationPageController._();
    return _this;
  }

  static NotificationPageController _this = NotificationPageController._();
  NotificationPageController._();

  //draw all notification from db like a bubble
  Future<Column> drawBubble(context, colorAlfa) async{
    List<Widget> widgets;
    List<CustomNotification.Notification> notifications = await _model.loadDBData();

    widgets = notifications.map((notification) {
      return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
          child: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ),
        onDismissed: (direction) {
          _this.dell(notification.id);
        },
        child: GestureDetector(
          onTap: () {
            _this.dell(notification.id);
            _this.gotoPage(const TipsPageView(title: "My Financial advice"), context);
          },
          child: Column(
            children: [
              _this.drawContainerDebt(101.0, 372.0, colorAlfa, notification),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
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

  //draw container for debt
  Container drawContainerDebt(height,width, colorAlfa, notification){
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
              child:
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(
                "${notification.body}",
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

  //save notification to db
  void save(id, title, body){
    _model.addNotificationToDb(id, title, body);
  }

  //delete notification from db
  void dell(id){
    _model.dellNotificationFromDB(id);
  }

}