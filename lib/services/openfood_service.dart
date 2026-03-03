import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenFoodService {

  static Future<Map<String, dynamic>?> fetchFromAPI(String barcode) async {
    try {
      final url =
          "https://world.openfoodfacts.org/api/v0/product/$barcode.json";

      final response =
      await http.get(Uri.parse(url)).timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) return null;

      final data = json.decode(response.body);

      if (data['status'] != 1) return null;

      final product = data['product'];

      String name =
          product['product_name'] ??
              product['product_name_en'] ??
              "Unknown Product";

      String brand =
          product['brands'] ??
              "Unknown";

      return {
        'barcode': barcode,
        'name': name.trim().isEmpty ? "Unknown Product" : name,
        'brand': brand.trim().isEmpty ? "Unknown" : brand,
        'price': 0.0,
        'stock': 0,
        'source': 'api',
      };

    } catch (e) {
      print("OpenFood API error: $e");
      return null;
    }
  }
}