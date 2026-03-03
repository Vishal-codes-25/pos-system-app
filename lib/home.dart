import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'scanner.dart';
import 'cart.dart';
import 'controllers/scan_controller.dart';
import 'sales_dashboard.dart'; // IMPORTANT

class HomePage extends StatefulWidget {
  final VoidCallback onGoToCart;

  const HomePage({super.key, required this.onGoToCart});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // ================== SCANNER ==================

  Future<void> openScanner() async {
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

    if (product['price'] != null) {
      product['price'] = (product['price'] as num).toDouble();
    }

    CartPage.addToCart(product);

    Future.microtask(() {
      widget.onGoToCart();
    });
  }

  // ================== UI ==================

  @override
  Widget build(BuildContext context) {
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

            // 🔥 TODAY SUMMARY
            const Text("Today's Summary",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('sales')
                  .snapshots(),
              builder: (context, snapshot) {

                double todaySales = 0;
                int totalOrders = 0;

                if (snapshot.hasData) {
                  final docs = snapshot.data!.docs;
                  final now = DateTime.now();

                  for (var doc in docs) {
                    final data = doc.data() as Map<String, dynamic>;

                    if (data['date'] == null) continue;

                    final date =
                    (data['date'] as Timestamp).toDate();

                    if (date.year == now.year &&
                        date.month == now.month &&
                        date.day == now.day) {
                      todaySales +=
                          (data['totalAmount'] ?? 0)
                              .toDouble();
                      totalOrders++;
                    }
                  }
                }

                return Row(
                  children: [
                    Expanded(
                      child: _summaryCard(
                          "Sales",
                          "₹${todaySales.toStringAsFixed(0)}"),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _summaryCard(
                          "Orders",
                          totalOrders.toString()),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 30),

            // 🔥 QUICK ACTIONS
            const Text("Quick Actions",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
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

  // ================== WIDGETS ==================

  Widget _summaryCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          Text(title),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown)),
        ],
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
          mainAxisAlignment:
          MainAxisAlignment.center,
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