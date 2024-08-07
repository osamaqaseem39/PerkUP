import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_admin_app/providers/login_provider.dart';
import 'package:perkup_admin_app/providers/perk_provider.dart';
import 'package:perkup_admin_app/screens/perk/perk_detail_screen.dart';
import 'package:perkup_admin_app/screens/perk/perk_form_screen.dart';

class PerkListScreen extends StatelessWidget {
  const PerkListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final perkProvider = Provider.of<PerkProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // Call fetchPerks on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = loginProvider.token;
      if (token != null) {
        perkProvider.fetchPerks(token);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerkFormScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<PerkProvider>(
        builder: (context, perkProvider, child) {
          if (perkProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (perkProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'An error occurred: ${perkProvider.errorMessage}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final token =
                          Provider.of<LoginProvider>(context, listen: false)
                              .token;
                      if (token != null) {
                        perkProvider.fetchPerks(token);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (perkProvider.perks.isEmpty) {
            return const Center(
              child: Text("No Data ATM"),
            );
          }

          return ListView.builder(
            itemCount: perkProvider.perks.length,
            itemBuilder: (context, index) {
              final perk = perkProvider.perks[index];
              return ListTile(
                title: Text(perk.perkName),
                subtitle: Text(perk.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PerkDetailScreen(perkID: perk.perkID),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
