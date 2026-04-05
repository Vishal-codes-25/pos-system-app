import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'scanner.dart';
import 'cart.dart';
import 'controllers/scan_controller.dart';
import 'sales_dashboard.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onGoToCart;

  const HomePage({super.key, required this.onGoToCart});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ================== SCANNER ==================

  Future<void> openScanner() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final barcode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScannerPage()),
    );

    if (!mounted) return;
    if (barcode == null || barcode.toString().isEmpty) return;

    Map<String, dynamic>? product =
    await ScanController.handleScan(barcode);

    if (!mounted) return;

    if (product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product not found')),
      );
      return;
    }

    // 🔍 Check Firestore
    final existing = await _firestore
        .collection('products')
        .where('barcode', isEqualTo: barcode)
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      product = existing.docs.first.data();
      product['id'] = existing.docs.first.id;
    } else {
      if ((product['source'] ?? 'database') == 'api') {
        final updated = await _showProductDialog(product);
        if (!mounted || updated == null) return;

        product = {
          'name': updated['name'],
          'brand': updated['brand'],
          'price': updated['price'],
          'barcode': barcode,
          'quantity': 1,
          'userId': user.uid,
          'createdAt': Timestamp.now(),
        };

        final doc =
        await _firestore.collection('products').add(product);

        product['id'] = doc.id;
      }
    }

    product['price'] = (product['price'] as num).toDouble();

    CartPage.addToCart(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product['name']} added to cart')),
    );

    widget.onGoToCart();
  }

  // ================== DIALOG ==================

  Future<Map<String, dynamic>?> _showProductDialog(
      Map<String, dynamic> product) async {
    final nameController =
    TextEditingController(text: product['name'] ?? '');
    final brandController =
    TextEditingController(text: product['brand'] ?? '');
    final priceController =
    TextEditingController(text: product['price']?.toString() ?? '');

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Confirm New Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Product Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: brandController,
              decoration: const InputDecoration(labelText: "Brand"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final price = double.tryParse(priceController.text);
              if (price == null) return;

              Navigator.pop(context, {
                'name': nameController.text.trim(),
                'brand': brandController.text.trim(),
                'price': price,
              });
            },
            child: const Text("Confirm"),
          )
        ],
      ),
    );
  }

  // ================== UI ==================

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Kirana POS"),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: openScanner,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 HEADER (UNCHANGED)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome Back 👋",
                          style:
                          TextStyle(color: Colors.white, fontSize: 16)),
                      SizedBox(height: 4),
                      Text("Start billing your customer",
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  Icon(Icons.store, color: Colors.white, size: 40)
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text("Quick Actions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            // 🔥 EXACT GRID UI (JUST ADDED INVENTORY)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _actionCard("Scan Product", Icons.qr_code_scanner, openScanner),
                _actionCard("Open Cart", Icons.shopping_cart, widget.onGoToCart),
                _actionCard("Inventory", Icons.inventory, () {
                  Navigator.pushNamed(context, '/inventory');
                }),
                _actionCard("Sales Dashboard", Icons.bar_chart, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SalesDashboardPage(),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(
      String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.brown),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}