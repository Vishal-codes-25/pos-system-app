import '../services/db_service.dart';

class ScanController {
  /// Main POS scan handler
  /// Flow:
  /// Flutter → PHP → (DB first → OpenFoodFacts fallback)
  static Future<Map<String, dynamic>?> handleScan(String barcode) async {
    try {
      if (barcode.isEmpty) return null;

      final response = await DBService.fetchProduct(barcode);

      if (response == null) return null;

      return {
        'barcode': response['barcode'] ?? barcode,
        'name': response['name'] ?? 'Unknown Product',
        'brand': response['brand'] ?? 'Unknown',
        'price': _toDouble(response['price']),
        'stock': _toInt(response['stock']),
        'source': response['source'] ?? 'database',
      };
    } catch (e) {
      // ignore: avoid_print
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
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is num) return value.toInt();
    return 0;
  }
}
