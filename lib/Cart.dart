import 'package:flutter/material.dart';
import 'layered_nav_bar.dart'; // ✅ Using the reusable nav bar

class CartItem {
  final String name;
  final int price;
  int quantity;

  CartItem({required this.name, required this.price, this.quantity = 1});

  int get total => price * quantity;
}

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [
    CartItem(name: 'Parle-G', price: 10, quantity: 2),
    CartItem(name: 'Sprite', price: 45, quantity: 1),
    CartItem(name: 'Pen', price: 10, quantity: 3),
    CartItem(name: 'ice-cream', price: 35, quantity: 2),
    CartItem(name: 'Milk', price: 28, quantity: 1),
  ];

  int get totalPrice => cartItems.fold(0, (sum, item) => sum + item.total);

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  void onNavTap(int index) {
    if (index == 2) return; // Already on Cart page
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/categories');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/product');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'My Cart',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) =>
                    buildCartItem(cartItems[index], index),
              ),
            ),
            const Divider(),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("\$$totalPrice",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Optional: Implement close logic
                    },
                    style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Implement checkout logic here
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    child: const Text('Checkout'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80), // space for nav bar
          ],
        ),
      ),
      bottomNavigationBar: LayeredNavBar(
        selectedIndex: 2,
        onTap: onNavTap,
      ),
    );
  }

  Widget buildCartItem(CartItem item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        child: ListTile(
          title: Text(item.name),
          subtitle: Text('\$${item.price}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Text('\$${item.total}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => removeItem(index),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
