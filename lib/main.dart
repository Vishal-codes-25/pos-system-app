import 'package:flutter/material.dart';
import 'Registration.dart';
import 'layered_nav_bar.dart';
import 'settings.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
