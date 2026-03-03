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

  // ================== SCANNER ==================

  Future<void> openScanner() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final barcode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScannerPage()),
    );

    if (barcode == null || barcode.toString().isEmpty) return;

    final product = await ScanController.handleScan(barcode);

    if (product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product not found')),
      );
      return;
    }

    // 🔥 CHECK IF PRODUCT ALREADY EXISTS IN FIRESTORE
    final existing = await FirebaseFirestore.instance
        .collection('products')
        .where('barcode', isEqualTo: barcode)
        .where('userId', isEqualTo: user.uid)
        .get();

    // 🔥 IF API PRODUCT AND NOT IN DB → SHOW POPUP
    if ((product['source'] ?? 'database') == 'api' &&
        existing.docs.isEmpty) {

      final updatedProduct = await _showProductDialog(product);
      if (updatedProduct == null) return;

      product
        ..['name'] = updatedProduct['name']
        ..['brand'] = updatedProduct['brand']
        ..['price'] = updatedProduct['price']
        ..['barcode'] = barcode
        ..['userId'] = user.uid
        ..['createdAt'] = Timestamp.now();

      await FirebaseFirestore.instance
          .collection('products')
          .add(product);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New product saved')),
      );
    }

    // 🔒 Ensure price is double
    if (product['price'] != null) {
      product['price'] = (product['price'] as num).toDouble();
    }

    // ✅ ADD TO CART
    CartPage.addToCart(product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );

    Future.microtask(() {
      widget.onGoToCart();
    });
  }

  // ================== PRODUCT CONFIRM POPUP ==================

  Future<Map<String, dynamic>?> _showProductDialog(
      Map<String, dynamic> product) async {

    final nameController =
    TextEditingController(text: product['name'] ?? '');

    final brandController =
    TextEditingController(text: product['brand'] ?? '');

    final priceController = TextEditingController(
      text: (product['price'] != null && product['price'] > 0)
          ? product['price'].toString()
          : '',
    );

    return showDialog<Map<String, dynamic>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Confirm New Product',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [

                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: brandController,
                  decoration: InputDecoration(
                    labelText: 'Brand',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                final price =
                double.tryParse(priceController.text);

                if (nameController.text.trim().isEmpty ||
                    brandController.text.trim().isEmpty ||
                    price == null ||
                    price <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                        Text("Please fill all fields correctly")),
                  );
                  return;
                }

                Navigator.pop(context, {
                  'name': nameController.text.trim(),
                  'brand': brandController.text.trim(),
                  'price': price,
                });
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  // ================== UI ==================

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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

            // 🔥 Welcome Card
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
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16)),
                      SizedBox(height: 4),
                      Text("Start billing your customer",
                          style: TextStyle(
                              color: Colors.white70)),
                    ],
                  ),
                  Icon(Icons.store,
                      color: Colors.white, size: 40)
                ],
              ),
            ),

            const SizedBox(height: 25),

            const Text("Quick Actions",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [

                _actionButton(
                  "Scan Product",
                  Icons.qr_code_scanner,
                  openScanner,
                ),

                _actionButton(
                  "Open Cart",
                  Icons.shopping_cart,
                  widget.onGoToCart,
                ),

                _actionButton(
                  "Sales Dashboard",
                  Icons.bar_chart,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const SalesDashboardPage(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(
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
            Icon(icon,
                size: 32,
                color: Colors.brown),
            const SizedBox(height: 8),
            Text(title,
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}