import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_customer_app/providers/login_provider.dart';
import 'package:perkup_customer_app/providers/perk_provider.dart';
import 'package:perkup_customer_app/screens/qrcode_screen.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final perkProvider = Provider.of<PerkProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // Fetch perks with PerkTypeID = 5 (Vouchers) on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = loginProvider.token;
      if (token != null) {
        perkProvider.fetchPerksByType(5, token); // PerkTypeID for Vouchers
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vouchers'),
      ),
      body: Consumer<PerkProvider>(
        builder: (context, perkProvider, child) {
          if (perkProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (perkProvider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'An error occurred: ${perkProvider.errorMessage}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        final token =
                            Provider.of<LoginProvider>(context, listen: false)
                                .token;
                        if (token != null) {
                          perkProvider.fetchPerksByType(5, token);
                        }
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (perkProvider.perks.isEmpty) {
            return const Center(
              child: Text("No vouchers available."),
            );
          }

          final userId = loginProvider.userId; // Get current user's ID

          return RefreshIndicator(
            onRefresh: () async {
              final token =
                  Provider.of<LoginProvider>(context, listen: false).token;
              if (token != null) {
                await perkProvider.fetchPerksByType(5, token);
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: perkProvider.perks.length,
              itemBuilder: (context, index) {
                final perk = perkProvider.perks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4.0,
                  child: ListTile(
                    leading: const Icon(Icons.card_giftcard,
                        color: Colors.blueAccent),
                    title: Text(
                      perk.perkName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(perk.description),
                    contentPadding: const EdgeInsets.all(16.0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRCodeGenerationScreen(
                            perkId: perk.perkID.toString(),
                            userId: userId, // Pass the user ID
                            perkName: perk.perkName,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
