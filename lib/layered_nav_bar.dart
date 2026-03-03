import 'package:flutter/material.dart';
import 'home.dart';
import 'sales_dashboard.dart';
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

  /// Screens created once (state will not reset)
  late final List<Widget> _screens = [
    HomePage(onGoToCart: () => _onItemTapped(2)),
    const SalesDashboardPage(),
    CartPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // keyboard safe

      /// Keeps all pages alive
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      /// ✅ Proper Bottom Navigation (No More Stack Issues)
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            height: 65,
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
                _buildNavItem(Icons.bar_chart, 1), // Sales Dashboard
                _buildNavItem(Icons.shopping_cart, 2),
                _buildNavItem(Icons.settings, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.brown : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 26,
          color: isSelected ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }
}