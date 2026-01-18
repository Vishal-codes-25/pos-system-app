import 'dart:convert';
import 'package:http/http.dart' as http;

class DBService {
  // 🔁 Backend file (confirmed working)
  static const String _baseUrl =
      'http://192.168.0.103/pos_api/pos_api.php';

  /// 🔍 Fetch product
  /// Backend handles:
  /// DB → OpenFoodFacts fallback
  static Future<Map<String, dynamic>?> fetchProduct(String barcode) async {
    try {
      if (barcode.isEmpty) return null;

      final response = await http
          .post(
        Uri.parse('$_baseUrl?action=get_product'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'barcode': barcode}),
      )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        print('❌ DB fetch failed: ${response.statusCode}');
        return null;
      }

      final Map<String, dynamic> data = json.decode(response.body);

      if (data['status'] != 'success') {
        print('⚠️ Product not found for barcode: $barcode');
        return null;
      }

      final product = Map<String, dynamic>.from(data['product']);

      return {
        'barcode': product['barcode'] ?? barcode,
        'name': product['name'] ?? 'Unknown Product',
        'brand': product['brand'] ?? 'Unknown',
        'price': _toDouble(product['price']),
        'stock': _toInt(product['stock']),
        'source': data['source'] ?? 'database',
      };
    } catch (e) {
      print('❌ DB fetch error: $e');
      return null;
    }
  }

  /// 💾 Save / update product
  static Future<bool> saveProduct(Map<String, dynamic> product) async {
    try {
      final response = await http
          .post(
        Uri.parse('$_baseUrl?action=save_product'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product),
      )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        print('❌ DB save failed: ${response.statusCode}');
        return false;
      }

      final data = json.decode(response.body);
      return data['status'] == 'success';
    } catch (e) {
      print('❌ DB save error: $e');
      return false;
    }
  }

  /// 📉 Update stock after checkout
  static Future<bool> updateStock(String barcode, int qty) async {
    try {
      final response = await http
          .post(
        Uri.parse('$_baseUrl?action=update_stock'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'barcode': barcode,
          'qty': qty,
        }),
      )
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        print('❌ Stock update failed: ${response.statusCode}');
        return false;
      }

      final data = json.decode(response.body);
      return data['status'] == 'success';
    } catch (e) {
      print('❌ Stock update error: $e');
      return false;
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
