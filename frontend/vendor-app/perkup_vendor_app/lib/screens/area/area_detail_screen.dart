import 'package:flutter/material.dart';
import 'package:perkup_vendor_app/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:perkup_vendor_app/providers/area_provider.dart';
import 'package:perkup_vendor_app/screens/area/area_form_screen.dart';

class AreaDetailScreen extends StatelessWidget {
  final int areaID;
  const AreaDetailScreen({super.key, required this.areaID});

  @override
  Widget build(BuildContext context) {
    final areaProvider = Provider.of<AreaProvider>(context, listen: false);
    final token = Provider.of<LoginProvider>(context, listen: false).token;
    final area = areaProvider.areas.firstWhere((area) => area.areaID == areaID);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Area Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AreaFormScreen(area: area),
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
                    title: const Text('Delete Area'),
                    content: const Text(
                        'Are you sure you want to delete this area?'),
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
                await areaProvider.deleteArea(areaID, token!);
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
            Text('Area ID: ${area.areaID}'),
            Text('Area Name: ${area.areaName}'),
          ],
        ),
      ),
    );
  }
}
