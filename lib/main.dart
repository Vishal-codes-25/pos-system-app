import 'package:flutter/material.dart';
import 'Registration.dart'; // Start screen
// You can also import 'login.dart' or 'home.dart' if needed

void main() {
  runApp(const POSApp());
}

class POSApp extends StatelessWidget {
  const POSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: RegistrationScreen(), // ✅ Start at Registration
    );
  }
}
