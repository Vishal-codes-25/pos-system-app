import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'auth_wrapper.dart';
import 'layered_nav_bar.dart';
import 'settings.dart';

// NEW
import 'pages/inventory_page.dart';
import 'pages/add_product.dart';

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
        scaffoldBackgroundColor: Colors.grey[100],
      ),

      home: const AuthWrapper(),

      routes: {
        '/home': (context) => const LayeredNavigationExample(),
        '/settings': (context) => const SettingsPage(),

        // ✅ NEW ROUTES
        '/inventory': (context) => const InventoryPage(),
        '/addProduct': (context) => const AddProductPage(),
      },
    );
  }
}