import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_user_app/providers/login_provider.dart';
import 'package:perkup_user_app/providers/perk_provider.dart';

class DiscountScreen extends StatelessWidget {
  const DiscountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final perkProvider = Provider.of<PerkProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // Fetch perks with PerkTypeID = 4 (Discounts) on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = loginProvider.token;
      if (token != null) {
        perkProvider.fetchPerksByType(4, token); // PerkTypeID for Discounts
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discounts'),
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
                          perkProvider.fetchPerksByType(4, token);
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
              child: Text("No discounts available."),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final token =
                  Provider.of<LoginProvider>(context, listen: false).token;
              if (token != null) {
                await perkProvider.fetchPerksByType(4, token);
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
                    leading:
                        const Icon(Icons.discount, color: Colors.purpleAccent),
                    title: Text(
                      perk.perkName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(perk.description),
                    contentPadding: const EdgeInsets.all(16.0),
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
