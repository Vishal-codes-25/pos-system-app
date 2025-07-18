import 'package:flutter/material.dart';
import 'home.dart';
//import 'categories.dart';
//import 'cart.dart';
//import 'product.dart';
import 'settings.dart';

class LayeredNavigationExample extends StatefulWidget {
  @override
  _LayeredNavigationExampleState createState() => _LayeredNavigationExampleState();
}

class _LayeredNavigationExampleState extends State<LayeredNavigationExample> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
   // CategoriesPage(),
   // CartPage(),
   // ProductPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _screens[_selectedIndex],
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
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
        ],
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
}
