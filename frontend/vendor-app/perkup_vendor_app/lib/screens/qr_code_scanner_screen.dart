import 'package:flutter/material.dart';
import 'package:perkup_vendor_app/screens/confirmation_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _controller;
  String? scannedText;

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (_controller != null) {
      _controller!.pauseCamera();
      _controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                scannedText != null ? 'Scanned: $scannedText' : 'Scan a code',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    await _requestCameraPermission();
    setState(() {
      _controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      scannedText = scanData.code;
      _handleQRData(scannedText);
      await controller.pauseCamera();
      // Delay to prevent multiple scans in quick succession
      await Future.delayed(const Duration(seconds: 1));
      await controller.resumeCamera();
    });
  }

  Future<void> _requestCameraPermission() async {
    // Implement camera permission request if needed
  }

  void _handleQRData(String? qrData) {
    if (qrData == null || qrData.isEmpty) {
      _showToast('Invalid QR Code');
      return;
    }

    // Parse QR data
    final parts = qrData.split('|');
    if (parts.length != 2) {
      _showToast('Invalid QR Code Format');
      return;
    }

    try {
      final perkId = _parseData(parts[0]);
      final userId = _parseData(parts[1]);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationScreen(
            perkId: double.parse(perkId).toInt(),
            userId: double.parse(userId).toInt(),
          ),
        ),
      );

      // Implement your logic to verify the perk or menu item here
      _showToast('Scanned Perk ID: $perkId, User ID: $userId');
    } catch (e) {
      _showToast('Error parsing QR Code');
    }
  }

  String _parseData(String part) {
    final data = part.split(':');
    if (data.length != 2) throw const FormatException('Invalid Data Format');
    return data[1];
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
}
