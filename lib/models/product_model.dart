import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  String brand;
  String category;
  double price;
  int quantity;
  String barcode;
  String userId;
  Timestamp createdAt;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.quantity,
    required this.barcode,
    required this.userId,
    required this.createdAt,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      category: data['category'] ?? '',
      price: (data['price'] as num).toDouble(),
      quantity: data['quantity'] ?? 0,
      barcode: data['barcode'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brand': brand,
      'category': category,
      'price': price,
      'quantity': quantity,
      'barcode': barcode,
      'userId': userId,
      'createdAt': createdAt,
    };
  }
}