/*
===========================================================================
  Author: xkulin01
  Description: Notification page displaying a list of notifications and providing the option to enable/disable notifications.
===========================================================================
*/

import 'package:flutter/material.dart';
import 'package:itu_dev/Api/NotificationApi.dart';
import 'package:itu_dev/Views/MainPageView.dart';
import 'package:itu_dev/Controllers/NotificationPageController.dart';

class NotificationsPageView extends StatefulWidget {
  const NotificationsPageView({super.key, required this.title});

  final String title;

  @override
  State<NotificationsPageView> createState() => _NotificationsPageViewState();
}

class _NotificationsPageViewState extends State<NotificationsPageView> {
  final NotificationPageController _controllerNotification = NotificationPageController();
  final List<String> notifications = List.generate(10, (index) => 'Notification ${index + 1}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        title: Text(widget.title, style: const TextStyle(fontSize: 28, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed:  () {
            _controllerNotification.gotoPage(const MainPageView(title: 'Hello,\nUser!'), context);
          },
        ),
        actions: <Widget>[
          // Toggle notifications button
          IconButton(
            icon: Icon(
              NotificationService.getNotificationsEnabled()
                  ? Icons.notifications
                  : Icons.notifications_off,
              color: Colors.white,
            ),
            iconSize: 35,
            onPressed: () async {
              // Toggle notifications status
              NotificationService.toggleNotifications(!NotificationService.areNotificationsEnabled);
              setState(() {});

              String text = '';
              if (!NotificationService.areNotificationsEnabled){
                text = 'Notifications disabled';
              } else {
                text = 'Notifications enabled';
              }

              // Show a snackbar with the status message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(text),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          width: double.infinity,
          child: FutureBuilder<Column?>(
            future: _controllerNotification.drawBubble(context, 255),
            builder: (context, AsyncSnapshot<Column?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData && snapshot.data != null) {
                return snapshot.data!;
              } else {
                return const Center(
                  child: Text('No data available'),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
