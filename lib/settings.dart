import 'package:flutter/material.dart';
import 'home.dart';
// import 'categories.dart'; // Add this when ready
import 'Cart.dart';
import 'product.dart';
import 'settings.dart'; // Current file
import 'layered_nav_bar.dart';
import 'profile.dart'; // <-- Add this import

class SettingsPage extends StatelessWidget {
  void onNavTap(BuildContext context, int index) {
    if (index == 4) return; // Already on Settings
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/categories');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/product');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/settings_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Main Content
          Column(
            children: [
              const SizedBox(height: 50),
              Row(
                children: const [
                  SizedBox(width: 20),
                  Icon(Icons.arrow_back_ios, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    'Settings',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    settingButton("Language"),
                    settingButton("Privacy Policy"),
                    settingButton("Password & Security"),
                    settingButton("Terms & Conditions"),
                    settingButton("Add Profile", onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    }),
                    const SizedBox(height: 20),
                    logoutButton(context),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: LayeredNavBar(
        selectedIndex: 4,
        onTap: (index) => onNavTap(context, index),
      ),
    );
  }

  Widget settingButton(String title, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 55,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, color: Colors.black)),
                const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context); // or Navigator.pushReplacementNamed(context, '/login');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[600],
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
