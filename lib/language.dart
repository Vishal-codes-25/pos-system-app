import 'package:flutter/material.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC5F2F3), // Light teal background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Language', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          buildLanguageTile(context, 'English'),
          buildLanguageTile(context, 'Hindi'),
          buildLanguageTile(context, 'Marathi'),
          const Spacer(),
          // Gift Image
          Image.asset(
            'assets/gifts.png', // Replace with your asset path
            height: 100,
          ),
          const SizedBox(height: 10),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black54,
        currentIndex: 4, // Change index according to current tab
        onTap: (index) {
          // Handle navigation here
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: 'Product'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget buildLanguageTile(BuildContext context, String language) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(language, style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            // Handle language change or navigation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$language selected')),
            );
          },
        ),
      ),
    );
  }
}
