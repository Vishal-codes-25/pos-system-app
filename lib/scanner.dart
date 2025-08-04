import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'db_helper.dart';
import 'api_service.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({Key? key}) : super(key: key);

  void _handleBarcode(BuildContext context, String barcode) async {
    final navigator = Navigator.of(context);

    // Safe copy of context
    final scaffoldContext = context;

    // Check local DB
    final localProduct = await DBHelper.getProduct(barcode);
    if (localProduct != null) {
      _showProductDialog(scaffoldContext, localProduct);
      return;
    }

    // Check API
    final apiProduct = await APIService.fetchProduct(barcode);
    if (apiProduct != null) {
      await DBHelper.insertProduct(apiProduct);
      _showProductDialog(scaffoldContext, apiProduct);
    } else {
      _showError(scaffoldContext, "Product not found.");
    }
  }

  void _showProductDialog(BuildContext context, Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(product['name']),
        content: Text('Price: ₹${product['price']}'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
      ),
    );
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Product")),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
            final code = barcodes.first.rawValue!;
            _handleBarcode(context, code);
          }
        },
      ),
    );
  }
}
