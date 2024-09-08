import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  MobileScannerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: (BarcodeCapture barcodeCapture) {
          // Handle the scanned barcode data
          final qrData = barcodeCapture.barcodes.first.rawValue;
          _handleQRData(qrData);
        },
      ),
    );
  }

  void _handleQRData(String? qrData) {
    if (qrData == null) return;

    // Parse QR data
    final parts = qrData.split('|');
    if (parts.length != 2) {
      _showToast('Invalid QR Code');
      return;
    }

    final perkId = parts[0].split(':')[1];
    final userId = parts[1].split(':')[1];

    // Implement your logic to verify the perk or menu item here
    // Example: Validate the perk ID and user ID, then show a confirmation message
    _showToast('Scanned Perk ID: $perkId, User ID: $userId');

    // Stop the camera after scanning
    _controller?.dispose();
    Navigator.pop(context);
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withOpacity(0.7),
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
