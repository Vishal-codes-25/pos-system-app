import 'package:flutter/material.dart';
import 'Registration.dart';
import 'home.dart';
import 'settings.dart';
import 'Cart.dart';
import 'product.dart';
import 'Profile.dart'; // <-- Added Profile page
// import 'categories.dart'; // Uncomment when CategoriesPage is implemented

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
      // initialRoute: '/home', // Optional: Use this if not starting with RegistrationPage
      home: RegistrationPage(), // App starts here
      routes: {
        '/home': (context) => HomePage(),
        '/settings': (context) => SettingsPage(),
        '/cart': (context) => CartPage(),
        '/product': (context) => ProductPage(),
        '/profile': (context) => ProfilePage(), // <-- Route for profile screen
        // '/categories': (context) => CategoriesPage(), // Add when ready
      },
    );
  }
}
