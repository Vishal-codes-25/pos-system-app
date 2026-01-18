import 'package:flutter/material.dart';
import 'home.dart';
import 'categories.dart';
import 'Cart.dart';
import 'settings.dart';

class LayeredNavigationExample extends StatefulWidget {
  const LayeredNavigationExample({super.key});

  @override
  State<LayeredNavigationExample> createState() =>
      _LayeredNavigationExampleState();
}

class _LayeredNavigationExampleState
    extends State<LayeredNavigationExample> {
  int _selectedIndex = 0;

  /// ✅ Widgets created ONCE and reused
  late final List<Widget> _screens = [
    HomePage(),        // index 0
    CategoriesPage(),  // index 1
    CartPage(),        // index 2 ✅ SINGLE CART INSTANCE
    SettingsPage(),    // index 3
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
          /// 🔥 Keeps state alive (VERY IMPORTANT)
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),

          /// 🧭 Bottom Navigation
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
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
                  _buildNavItem(Icons.settings, 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: CircleAvatar(
        radius: 22,
        backgroundColor:
        isSelected ? Colors.brown : Colors.transparent,
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }
}
