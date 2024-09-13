/*
===========================================================================
  Author: xkulin01
  Description: NotificationService class for managing and displaying notifications
===========================================================================
*/
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:itu_dev/Controllers/NotificationPageController.dart';
import 'package:itu_dev/Controllers/TipsPageController.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  // Controller instances for managing notification and tips data
  final NotificationPageController _controllerNot = NotificationPageController();
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  // Variable to track if notifications are enabled
  static bool areNotificationsEnabled = true;
  static const String notificationsKey = 'notificationsEnabled';

  // Initialize notification settings and timer
  Future<void> initNotification() async {
    // Android notification settings
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('logo');

    // Read notification settings from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    areNotificationsEnabled = prefs.getBool(notificationsKey) ?? true;

    // iOS notification settings
    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title, String? body,
            String? payload) async {});

    // General initialization settings
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    // Initialize the FlutterLocalNotificationsPlugin
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse response) async {});

    // Start the notification timer
    startNotificationTimer();
  }

  // Start a periodic timer for sending notifications
  void startNotificationTimer() {
    final _notificationService = NotificationService();
    Timer.periodic(const Duration(hours: 24), (timer) async {
      if (areNotificationsEnabled) {
        // Generate unique ID for each notification
        int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

        // Prepare notification content
        String title = 'Read Your Financial Advice!';
        String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(
            DateTime.now().toLocal());
        String tipName = (await TipsPageController().getRandomTip()).title;
        String body = 'Financial Tip of the Day: ${tipName}\nTime of receipt: ${formattedDateTime}';

        // Show notification and save it in the controller
        _notificationService.showNotification(
          id: id,
          title: title,
          body: body,
        );
        _controllerNot.save(id, title, body);
      }
    });
  }

  // Toggle the notification state (enabled or disabled)
  static void toggleNotifications(bool enable) async{
    areNotificationsEnabled = enable;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(notificationsKey, areNotificationsEnabled);
  }

  // Get the current notification state
  static bool getNotificationsEnabled() {
    return areNotificationsEnabled;
  }

  // Show a notification with the provided details
  Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  // Define notification details, including platform-specific settings
  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }
}
