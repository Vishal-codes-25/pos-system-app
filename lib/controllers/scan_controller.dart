import '../services/firebase_service.dart';
import '../services/openfood_service.dart';

class ScanController {

  /// 🔎 Main Scan Flow
  /// 1️⃣ Check Firebase
  /// 2️⃣ If not found → OpenFoodFacts
  static Future<Map<String, dynamic>?> handleScan(String barcode) async {
    try {
      if (barcode.isEmpty) return null;

      // ===============================
      // 1️⃣ CHECK FIRESTORE FIRST
      // ===============================
      final firebaseProduct =
      await FirebaseService.fetchProduct(barcode);

      if (firebaseProduct != null) {
        return {
          'barcode': firebaseProduct['barcode'] ?? barcode,
          'name': firebaseProduct['name'] ?? 'Unknown Product',
          'brand': firebaseProduct['brand'] ?? 'Unknown',
          'price': _toDouble(firebaseProduct['price']),
          'stock': _toInt(firebaseProduct['stock']),
          'source': 'firebase',
        };
      }

      // ===============================
      // 2️⃣ IF NOT FOUND → CALL API
      // ===============================
      final apiProduct =
      await OpenFoodService.fetchFromAPI(barcode);

      if (apiProduct != null) {
        return {
          'barcode': apiProduct['barcode'] ?? barcode,
          'name': apiProduct['name'] ?? 'Unknown Product',
          'brand': apiProduct['brand'] ?? 'Unknown',
          'price': _toDouble(apiProduct['price']),
          'stock': _toInt(apiProduct['stock']),
          'source': 'api',
        };
      }

      // ❌ Not found anywhere
      return null;

    } catch (e) {
      print('ScanController error: $e');
      return null;
    }
  }

  // ================== HELPERS ==================

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}