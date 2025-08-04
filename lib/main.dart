import 'package:flutter/material.dart';
import 'Registration.dart';
import 'home.dart';
import 'settings.dart';
import 'Cart.dart';
import 'product.dart';
import 'layered_nav_bar.dart'; // Main screen with nav bar

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
      home: RegistrationPage(), // First screen when app launches
      routes: {
        '/home': (context) => LayeredNavigationExample(), // ✅ main screen after login
        '/settings': (context) => SettingsPage(),
        '/cart': (context) => CartPage(),
        '/product': (context) => ProductPage(),
        // Add categories if implemented later
        // '/categories': (context) => CategoriesPage(),
      },
    );
  }
}
