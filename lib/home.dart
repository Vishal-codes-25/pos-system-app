import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POS Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // TODO: Clear session or perform logout
              Navigator.pop(context); // Goes back to login
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to POS App!',
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
