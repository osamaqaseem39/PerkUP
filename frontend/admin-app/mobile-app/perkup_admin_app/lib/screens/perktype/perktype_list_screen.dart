import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_admin_app/providers/login_provider.dart';
import 'package:perkup_admin_app/providers/perktype_provider.dart';
import 'package:perkup_admin_app/screens/perktype/perktype_detail_screen.dart';
import 'package:perkup_admin_app/screens/perktype/perktype_form_screen.dart';

class PerkTypeListScreen extends StatelessWidget {
  const PerkTypeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final perkTypeProvider =
        Provider.of<PerkTypeProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // Call fetchPerkTypes on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = loginProvider.token;
      if (token != null) {
        perkTypeProvider.fetchPerkTypes(token);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perk Types'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PerkTypeFormScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<PerkTypeProvider>(
        builder: (context, perkTypeProvider, child) {
          if (perkTypeProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (perkTypeProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'An error occurred: ${perkTypeProvider.errorMessage}',
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
                        perkTypeProvider.fetchPerkTypes(token);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (perkTypeProvider.perkTypes.isEmpty) {
            return const Center(
              child: Text("No Perk Types Available"),
            );
          }

          return ListView.builder(
            itemCount: perkTypeProvider.perkTypes.length,
            itemBuilder: (context, index) {
              final perkType = perkTypeProvider.perkTypes[index];
              return ListTile(
                title: Text(perkType.typeName),
                subtitle: Text(perkType.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PerkTypeDetailScreen(perkTypeID: perkType.perkTypeID),
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
