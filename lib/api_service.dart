import 'dart:convert';
import 'package:http/http.dart' as http;

class APIService {
  static const String _baseUrl =
      'http://192.168.0.103/pos_api/pos_api.php';

  static const Duration _timeout = Duration(seconds: 10);

  static Future<Map<String, dynamic>?> fetchProduct(String barcode) async {
    try {
      final response = await http
          .post(
        Uri.parse('$_baseUrl?action=get_product'),
        body: {'barcode': barcode},
      )
          .timeout(_timeout);

      if (response.statusCode != 200) return null;

      final data = json.decode(response.body);

      if (data['status'] == 'success') {
        final p = data['product'];
        return {
          'barcode': p['barcode'],
          'name': p['name'] ?? 'Unknown',
          'brand': p['brand'] ?? 'Unknown',
          'price': double.tryParse(p['price'].toString()) ?? 0.0,
          'stock': int.tryParse(p['stock'].toString()) ?? 0,
        };
      }

      return null;
    } catch (e) {
      print('fetchProduct error: $e');
      return null;
    }
  }

  static Future<bool> saveProduct(Map<String, dynamic> product) async {
    try {
      final response = await http
          .post(
        Uri.parse('$_baseUrl?action=save_product'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'barcode': product['barcode'],
          'name': product['name'],
          'brand': product['brand'],
          'price': product['price'],
          'stock': product['stock'] ?? 0,
        }),
      )
          .timeout(_timeout);

      if (response.statusCode != 200) return false;

      final data = json.decode(response.body);
      return data['status'] == 'success';
    } catch (e) {
      print('saveProduct error: $e');
      return false;
    }
  }

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
          .timeout(_timeout);

      if (response.statusCode != 200) return false;

      final data = json.decode(response.body);
      return data['status'] == 'success';
    } catch (e) {
      print('updateStock error: $e');
      return false;
    }
  }
}
