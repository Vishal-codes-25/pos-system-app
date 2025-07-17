import 'package:flutter/material.dart';
import 'home.dart';

class SettingsPage extends StatelessWidget {
  void navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
          }
          // Add other page navigations as needed
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFFB38E5D), // Gold-brown header
        title: const Text('Settings'),
        leading: const Icon(Icons.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            settingButton(context, "Languages"),
            settingButton(context, "Privacy Policy"),
            settingButton(context, "Password & Security"),
            settingButton(context, "Terms & Condition"),
            settingButton(context, "Previous Bookings"),
            const SizedBox(height: 20),
            logoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget settingButton(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        onPressed: () {
          // Add individual navigation if needed
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFB38E5D),
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, color: Colors.white)),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget logoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context); // or Navigator.push to login page
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFB38E5D),
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("Logout", style: TextStyle(fontSize: 16, color: Colors.white)),
          Icon(Icons.logout, color: Colors.white),
        ],
      ),
    );
  }
}
