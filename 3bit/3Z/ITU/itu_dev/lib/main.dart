/*
===========================================================================
  Author: xkulin01
  Description: Main entry point for the Flutter application
===========================================================================
*/

import 'package:flutter/material.dart';
import 'package:itu_dev/Views/MainPageView.dart';
import 'package:itu_dev/Api/NotificationApi.dart';

// The main function that runs the Flutter application
void main() {
  // Ensure Flutter is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize notification services
  NotificationService().initNotification();

  // Run the app by calling the MyApp widget
  runApp(const MyApp());
}

// MyApp class represents the root of the Flutter application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Build method constructs the overall UI of the application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Set the title of the app
      title: 'ITU proj',


      // Disable the debug banner in the top-right corner
      debugShowCheckedModeBanner: false,

      // Define the theme for the entire app
      theme: ThemeData(
        // Customize the appearance of the app bar
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 87, 80, 147),
          iconTheme: IconThemeData(color: Colors.white),
        ),

        // Set the background color of the scaffold
        scaffoldBackgroundColor: const Color.fromARGB(255, 87, 80, 147),

        // Set the default font family for the entire app
        fontFamily: "MiriamLibre",

        // Enable the use of Material 3 design
        useMaterial3: true,
      ),

      // Set the initial screen of the app to MainPageView
      home: const MainPageView(title: 'Hello,\nUser!'),
    );
  }
}
