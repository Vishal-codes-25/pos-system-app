import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 🔍 Get Product
  static Future<Map<String, dynamic>?> fetchProduct(String barcode) async {
    try {
      final doc =
      await _db.collection('products').doc(barcode).get();

      if (!doc.exists) return null;

      return doc.data();
    } catch (e) {
      print("Fetch error: $e");
      return null;
    }
  }

  /// 💾 Save Product
  static Future<bool> saveProduct(Map<String, dynamic> product) async {
    try {
      await _db
          .collection('products')
          .doc(product['barcode'])
          .set({
        ...product,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print("Save error: $e");
      return false;
    }
  }

  /// 📉 Update Stock
  static Future<bool> updateStock(
      String barcode, int qty) async {
    try {
      final docRef =
      _db.collection('products').doc(barcode);

      await _db.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        if (!snapshot.exists) return;

        int currentStock = snapshot['stock'] ?? 0;

        transaction.update(docRef, {
          'stock': currentStock - qty
        });
      });

      return true;
    } catch (e) {
      print("Stock error: $e");
      return false;
    }
  }
}