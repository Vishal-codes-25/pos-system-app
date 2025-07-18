import 'package:flutter/material.dart';
import 'home.dart';
//import 'categories.dart';
//import 'cart.dart';
//import 'product.dart';
import 'settings.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 4;

  final List<Widget> _screens = [
    HomePage(),
  //  CategoriesPage(),
  //  CartPage(),
  //  ProductPage(),
    SettingsPage(), // current page
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => _screens[index]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Color(0xFFB38E5D),
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
      // Layered Navigation Bar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 0),
              _buildNavItem(Icons.category, 1),
              _buildNavItem(Icons.shopping_cart, 2),
              _buildNavItem(Icons.production_quantity_limits, 3),
              _buildNavItem(Icons.settings, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: CircleAvatar(
        backgroundColor: _selectedIndex == index ? Colors.brown[300] : Colors.transparent,
        radius: 22,
        child: Icon(
          icon,
          color: _selectedIndex == index ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }

  Widget settingButton(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ElevatedButton(
        onPressed: () {},
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
        Navigator.pop(context); // Or push login screen
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
