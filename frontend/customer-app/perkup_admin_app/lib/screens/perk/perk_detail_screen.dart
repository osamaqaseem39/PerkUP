import 'package:flutter/material.dart';
import 'package:perkup_user_app/providers/login_provider.dart';
import 'package:perkup_user_app/providers/perktype_provider.dart';
import 'package:provider/provider.dart';
import 'package:perkup_user_app/providers/perk_provider.dart';
import 'package:perkup_user_app/screens/perk/perk_form_screen.dart';

class PerkDetailScreen extends StatelessWidget {
  final int perkID;
  const PerkDetailScreen({super.key, required this.perkID});

  @override
  Widget build(BuildContext context) {
    final perkProvider = Provider.of<PerkProvider>(context, listen: false);
    final token = Provider.of<LoginProvider>(context, listen: false).token;
    final perk = perkProvider.perks.firstWhere((p) => p.perkID == perkID);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perk Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final token =
                  Provider.of<LoginProvider>(context, listen: false).token!;
              await Provider.of<PerkTypeProvider>(context, listen: false)
                  .fetchPerkTypes(token);
              Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(
                  builder: (context) => PerkFormScreen(perk: perk),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              bool? deleteConfirmed = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete Perk'),
                    content: const Text(
                        'Are you sure you want to delete this perk?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );

              if (deleteConfirmed == true) {
                await perkProvider.deletePerk(perkID, token!);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Perk ID: ${perk.perkID}'),
            Text('Perk Type: ${perk.perkType}'),
            Text('Perk Name: ${perk.perkName}'),
            Text('Description: ${perk.description}'),
            Text('Value: ${perk.value}'),
            Text('Start Date: ${perk.startDate}'),
            Text('End Date: ${perk.endDate}'),
            Text('Is Active: ${perk.isActive}'),
            Text('Min Purchase Amount: ${perk.minPurchaseAmount}'),
            Text('Max Discount Amount: ${perk.maxDiscountAmount}'),
            Text('Created By: ${perk.createdBy}'),
            Text('Created At: ${perk.createdAt}'),
            Text('Updated By: ${perk.updatedBy}'),
            Text('Updated At: ${perk.updatedAt}'),
          ],
        ),
      ),
    );
  }
}
