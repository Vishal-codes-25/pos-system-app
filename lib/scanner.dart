import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({Key? key}) : super(key: key);

  void fetchProductByBarcode(String barcode, BuildContext context) async {
    // Replace with your API endpoint
    final apiUrl = 'https://yourapi.com/products?barcode=$barcode';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scanned: $barcode (Send to API)')),
    );

    // TODO: Add real HTTP request here if needed using `http` package
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: (BarcodeCapture capture) {
          final List<Barcode> barcodes = capture.barcodes;
          if (barcodes.isNotEmpty) {
            final String? code = barcodes.first.rawValue;
            if (code != null) {
              fetchProductByBarcode(code, context);
              Navigator.pop(context, code);
            }
          }
        },
      ),
    );
  }
}
