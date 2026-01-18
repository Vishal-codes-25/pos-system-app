import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool _isScanning = true;
  final MobileScannerController _controller = MobileScannerController();

  @override
  void dispose() {
    _controller.dispose(); // ✅ Prevent camera leak
    super.dispose();
  }

  void _closeScanner() {
    if (!_isScanning) return;
    _isScanning = false;
    _controller.stop();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Scan Barcode'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _closeScanner,
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            fit: BoxFit.cover,
            onDetect: (BarcodeCapture capture) {
              if (!_isScanning || !mounted) return;
              if (capture.barcodes.isEmpty) return;

              final String? code = capture.barcodes.first.rawValue;
              if (code == null || code.isEmpty) return;

              _isScanning = false;

              // ✅ Stop camera immediately
              _controller.stop();

              // ✅ Return scanned barcode
              Navigator.pop(context, code);
            },
          ),

          // 🔲 Scan Box Overlay
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.greenAccent,
                  width: 3,
                ),
              ),
            ),
          ),

          // 📝 Instruction
          const Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Text(
              'Align barcode inside the box',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
