import 'package:flutter/material.dart';
import 'home.dart';
import 'categories.dart';
import 'cart.dart';
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

  /// Screens created once
  late final List<Widget> _screens = [
    HomePage(),
    CategoriesPage(),
    CartPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      extendBody: true,

      /// 🔥 VERY IMPORTANT
      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [
          /// Keeps state alive
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),

          /// Floating Nav (moves above keyboard)
          Positioned(
            left: 16,
            right: 16,
            bottom: bottomInset > 0 ? bottomInset + 12 : 16,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
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
