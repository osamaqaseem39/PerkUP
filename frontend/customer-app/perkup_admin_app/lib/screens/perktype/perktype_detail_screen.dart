import 'package:flutter/material.dart';
import 'package:perkup_user_app/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:perkup_user_app/providers/perktype_provider.dart';
import 'package:perkup_user_app/screens/perktype/perktype_form_screen.dart';

class PerkTypeDetailScreen extends StatelessWidget {
  final int perkTypeID;
  const PerkTypeDetailScreen({super.key, required this.perkTypeID});

  @override
  Widget build(BuildContext context) {
    final perkTypeProvider =
        Provider.of<PerkTypeProvider>(context, listen: false);
    final token = Provider.of<LoginProvider>(context, listen: false).token;
    final perkType = perkTypeProvider.perkTypes
        .firstWhere((pt) => pt.perkTypeID == perkTypeID);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perk Type Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerkTypeFormScreen(perkType: perkType),
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
                    title: const Text('Delete Perk Type'),
                    content: const Text(
                        'Are you sure you want to delete this perk type?'),
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
                await perkTypeProvider.deletePerkType(perkTypeID, token!);
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
            Text('Perk Type ID: ${perkType.perkTypeID}'),
            Text('Type Name: ${perkType.typeName}'),
            Text('Description: ${perkType.description}'),
            Text('Created By: ${perkType.createdBy}'),
            Text('Created At: ${perkType.createdAt}'),
            Text('Updated By: ${perkType.updatedBy}'),
            Text('Updated At: ${perkType.updatedAt}'),
          ],
        ),
      ),
    );
  }
}
