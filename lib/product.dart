import 'package:flutter/material.dart';
import 'home.dart';
import 'layered_nav_bar.dart'; // ✅ Use shared nav bar
import 'settings.dart';        // Required for navigation

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int _selectedIndex = 3;

  List<Map<String, dynamic>> products = [
    {'name': 'Parle-G', 'price': 10, 'quantity': 2},
    {'name': 'Sprite', 'price': 45, 'quantity': 1},
    {'name': 'Pen', 'price': 10, 'quantity': 3},
    {'name': 'Ice Cream', 'price': 35, 'quantity': 2},
  ];

  final TextEditingController _searchController = TextEditingController();

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;

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
      // Already on Product page
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SettingsPage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/settings_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      Icon(Icons.arrow_back_ios, size: 20),
                      SizedBox(width: 8),
                      Icon(Icons.inventory_2_outlined, size: 22),
                      SizedBox(width: 6),
                      Text("Add Product", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: "Search for Add Product",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Product List
                  Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return _buildProductItem(products[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Close"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Checkout", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: LayeredNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(product['name'], style: const TextStyle(fontSize: 15))),
          Expanded(child: Text("\₹${product['price']}")),
          Expanded(
            child: Container(
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text("${product['quantity']}", style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                product['quantity']++;
              });
            },
            icon: const Icon(Icons.add_circle, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
