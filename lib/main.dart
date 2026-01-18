import 'package:flutter/material.dart';
import 'Registration.dart';
import 'layered_nav_bar.dart';
import 'settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),

      // 🔥 First screen
      home: RegistrationPage(),

      // ✅ Only MAIN shell routes
      routes: {
        '/home': (context) => LayeredNavigationExample(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
