import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class QRCodeGenerationScreen extends StatelessWidget {
  final String perkId;
  final int? userId;
  final String perkName;

  const QRCodeGenerationScreen({
    super.key,
    required this.perkId,
    required this.userId,
    required this.perkName,
  });

  @override
  Widget build(BuildContext context) {
    final qrData = 'perkID:$perkId|perk:$perkName|user:$userId';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Show this QR code to the Cashier to redeem the perk.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              PrettyQr(
                data: qrData,
                size: 200.0,
                image: const AssetImage(
                    'assets/images/login_image.png'), // Optional: Add a logo in the center
                typeNumber: 3, // Customize the type number if needed
                errorCorrectLevel:
                    QrErrorCorrectLevel.M, // Customize error correction level
                roundEdges: true, // Make the edges rounded
              ),
              const SizedBox(height: 20),
              Text(
                'Perk: $perkName',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
