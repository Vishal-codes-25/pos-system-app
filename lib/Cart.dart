import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// ================== CART ITEM MODEL ==================

class CartItem {
  final String barcode;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.barcode,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

/// ================== CART PAGE ==================

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static final List<CartItem> cartItems = [];
  static final ValueNotifier<int> cartRefresh = ValueNotifier<int>(0);

  static void addToCart(Map<String, dynamic> product) {
    if (product['barcode'] == null ||
        product['name'] == null ||
        product['price'] == null) return;

    final index =
    cartItems.indexWhere((item) => item.barcode == product['barcode']);

    if (index >= 0) {
      cartItems[index].quantity++;
    } else {
      cartItems.add(
        CartItem(
          barcode: product['barcode'].toString(),
          name: product['name'].toString(),
          price: (product['price'] as num).toDouble(),
        ),
      );
    }

    cartRefresh.value++;
  }

  static void increaseQty(int index) {
    cartItems[index].quantity++;
    cartRefresh.value++;
  }

  static void decreaseQty(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
    } else {
      cartItems.removeAt(index);
    }
    cartRefresh.value++;
  }

  static void removeItem(int index) {
    cartItems.removeAt(index);
    cartRefresh.value++;
  }

  static void clearCart() {
    cartItems.clear();
    cartRefresh.value++;
  }

  @override
  State<CartPage> createState() => _CartPageState();
}

/// ================== CART UI ==================

class _CartPageState extends State<CartPage> {
  final TextEditingController _cashController = TextEditingController();
  final FocusNode _cashFocusNode = FocusNode();

  double get totalPrice =>
      CartPage.cartItems.fold(0, (sum, item) => sum + item.total);

  double get cashReceived =>
      double.tryParse(_cashController.text.trim()) ?? 0;

  double get change => cashReceived - totalPrice;

  Future<void> confirmSale() async {
    FocusScope.of(context).unfocus();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (CartPage.cartItems.isEmpty) return;
    if (cashReceived < totalPrice) return;

    try {
      final saleData = {
        "userId": user.uid,
        "date": Timestamp.now(),
        "totalAmount": totalPrice,
        "cashReceived": cashReceived,
        "change": change,
        "items": CartPage.cartItems.map((item) => {
          "barcode": item.barcode,
          "name": item.name,
          "price": item.price,
          "quantity": item.quantity,
        }).toList(),
      };

      await FirebaseFirestore.instance.collection("sales").add(saleData);

      // 🔥 STOCK UPDATE (VERY IMPORTANT)
      for (var item in CartPage.cartItems) {
        final query = await FirebaseFirestore.instance
            .collection('products')
            .where('barcode', isEqualTo: item.barcode)
            .where('userId', isEqualTo: user.uid)
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          final doc = query.docs.first;
          final currentQty = doc['quantity'] ?? 0;

          await doc.reference.update({
            'quantity': currentQty - item.quantity,
          });
        }
      }

      CartPage.clearCart();
      _cashController.clear();

      _showMessage("Sale Completed ✅");
    } catch (e) {
      _showMessage("Error saving sale");
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _cashController.dispose();
    _cashFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // 🔥 TAP OUTSIDE CLOSES
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            'My Cart',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: CartPage.cartRefresh,
            builder: (context, _, __) {
              final cartItems = CartPage.cartItems;

              return Column(
                children: [
                  Expanded(
                    child: cartItems.isEmpty
                        ? const Center(
                      child: Text(
                        'Your cart is empty',
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey),
                      ),
                    )
                        : ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (_, index) =>
                          _buildCartItem(cartItems[index], index),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildRow("Total", totalPrice),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _cashController,
                          focusNode: _cashFocusNode,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Cash Received",
                            prefixText: "₹ ",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 10),
                        _buildRow("Change", change < 0 ? 0 : change),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: confirmSale,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                            ),
                            child: const Text(
                              "CONFIRM SALE",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title, double amount) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        Text("₹${amount.toStringAsFixed(2)}",
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCartItem(CartItem item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 6),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: const TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(
                        '₹${item.price.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons
                        .remove_circle_outline),
                    onPressed: () =>
                        CartPage.decreaseQty(index),
                  ),
                  Text('${item.quantity}',
                      style: const TextStyle(
                          fontWeight:
                          FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons
                        .add_circle_outline),
                    onPressed: () =>
                        CartPage.increaseQty(index),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                      '₹${item.total.toStringAsFixed(0)}',
                      style: const TextStyle(
                          fontWeight:
                          FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: Colors.red,
                        size: 20),
                    onPressed: () =>
                        CartPage.removeItem(index),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}