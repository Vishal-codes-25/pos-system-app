import 'package:flutter/material.dart';

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
  static final ValueNotifier<int> cartNotifier = ValueNotifier<int>(0);

  static void addToCart(Map<String, dynamic> product) {
    if (product['barcode'] == null ||
        product['name'] == null ||
        product['price'] == null) return;

    final index = cartItems.indexWhere(
          (item) => item.barcode == product['barcode'],
    );

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

    cartNotifier.value++;
  }

  static void increaseQty(int index) {
    cartItems[index].quantity++;
    cartNotifier.value++;
  }

  static void decreaseQty(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity--;
    } else {
      cartItems.removeAt(index);
    }
    cartNotifier.value++;
  }

  static void removeItem(int index) {
    cartItems.removeAt(index);
    cartNotifier.value++;
  }

  @override
  State<CartPage> createState() => _CartPageState();
}

/// ================== CART UI ==================

class _CartPageState extends State<CartPage> {
  int get totalPrice => CartPage.cartItems.fold(
    0,
        (sum, item) => sum + item.total.round(),
  );

  static const double _navBarSpace = 90; // height for layered nav

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      /// ❌ NO BACK BUTTON (important)
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
          valueListenable: CartPage.cartNotifier,
          builder: (_, __, ___) {
            final cartItems = CartPage.cartItems;

            return Column(
              children: [
                /// 🧾 CART ITEMS
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
                    padding: const EdgeInsets.only(
                      bottom: _navBarSpace,
                    ),
                    itemCount: cartItems.length,
                    itemBuilder: (_, index) =>
                        _buildCartItem(cartItems[index], index),
                  ),
                ),

                /// 💰 TOTAL BAR (STICKY)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.only(bottom: _navBarSpace),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.black12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "₹$totalPrice",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// ================== CART ITEM TILE ==================

  Widget _buildCartItem(CartItem item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              /// NAME + PRICE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text('₹${item.price.toStringAsFixed(2)}'),
                  ],
                ),
              ),

              /// QTY CONTROLS
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () => CartPage.decreaseQty(index),
                  ),
                  Text(
                    '${item.quantity}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => CartPage.increaseQty(index),
                  ),
                ],
              ),

              /// ITEM TOTAL + REMOVE
              Column(
                children: [
                  Text(
                    '₹${item.total.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon:
                    const Icon(Icons.close, color: Colors.red, size: 20),
                    onPressed: () => CartPage.removeItem(index),
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
