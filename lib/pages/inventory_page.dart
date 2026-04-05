import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/inventory_service.dart';
import '../models/product_model.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = InventoryService();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/addProduct');
            },
          )
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: service.getProducts(user.uid),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!;

          if (products.isEmpty) {
            return const Center(child: Text("No products"));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final p = products[index];

              return ListTile(
                title: Text(p.name),
                subtitle: Text("Stock: ${p.quantity} | ₹${p.price}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (p.quantity < 5)
                      const Icon(Icons.warning, color: Colors.red),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        service.deleteProduct(p.id);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}