import 'package:flutter/material.dart';
import 'Registration.dart';
import 'home.dart';
import 'settings.dart'; // Imported settings page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: RegistrationPage(), // Launches registration screen by default
      routes: {
        '/home': (context) => HomePage(),         // Navigates to Home screen
        '/settings': (context) => SettingsPage(), // Navigates to Settings screen
        // '/login': (context) => LoginPage(),     // Uncomment when needed
      },
    );
  }
}
