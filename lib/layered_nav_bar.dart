import 'package:flutter/material.dart';

class LayeredNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const LayeredNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0),
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, Icons.home, 0, "Home"),
            _buildNavItem(context, Icons.category, 1, "Categories"),
            _buildNavItem(context, Icons.shopping_cart, 2, "Cart"),
            _buildNavItem(context, Icons.production_quantity_limits, 3, "Product"),
            _buildNavItem(context, Icons.settings, 4, "Settings"),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, int index, String label) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.black : Colors.grey[500]),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: isSelected ? Colors.black : Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
