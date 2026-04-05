import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/inventory_service.dart';
import '../models/product_model.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

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
      appBar: AppBar(title: const Text("Select Product")),
      body: StreamBuilder<List<Product>>(
        stream: service.getProducts(user.uid),
        builder: (context, snapshot) {

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!;

          if (products.isEmpty) {
            return const Center(child: Text("No products found"));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final p = products[index];

              return ListTile(
                title: Text(p.name),
                subtitle: Text("₹${p.price} | Stock: ${p.quantity}"),
                onTap: () => _showDialog(context, p, service),
              );
            },
          );
        },
      ),
    );
  }

  void _showDialog(
      BuildContext context, Product product, InventoryService service) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product.name),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Quantity"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final qty = int.tryParse(controller.text);
              if (qty == null) return;

              await service.updateProduct(
                Product(
                  id: product.id,
                  name: product.name,
                  brand: product.brand,
                  category: product.category,
                  price: product.price,
                  quantity: product.quantity + qty,
                  barcode: product.barcode,
                  userId: product.userId,
                  createdAt: product.createdAt,
                ),
              );

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Stock Updated")),
              );
            },
            child: const Text("Update"),
          )
        ],
      ),
    );
  }
}