import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'api_service.dart';
import 'product.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isProcessing = false;

  Future<void> _handleBarcode(String barcode) async {
    if (_isProcessing) return;
    _isProcessing = true;

    // ⛔ Stop camera while processing
    await _controller.stop();

    try {
      // 🔥 DIRECT API CALL (XAMPP)
      final apiProduct = await APIService.fetchProduct(barcode);

      if (apiProduct != null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductPage(product: apiProduct),
          ),
        );
      } else {
        _showError("Product not found");
      }
    } catch (e) {
      _showError("Something went wrong");
    } finally {
      _isProcessing = false;
      // ▶ Resume scanning when returning
      await _controller.start();
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Product")),
      body: MobileScanner(
        controller: _controller,
        onDetect: (BarcodeCapture capture) {
          final barcode = capture.barcodes.first.rawValue;
          if (barcode != null) {
            _handleBarcode(barcode);
          }
        },
      ),
    );
  }
}
