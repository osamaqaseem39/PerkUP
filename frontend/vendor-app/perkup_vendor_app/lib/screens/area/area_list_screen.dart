import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_vendor_app/providers/login_provider.dart';
import 'package:perkup_vendor_app/providers/area_provider.dart';
import 'package:perkup_vendor_app/screens/area/area_detail_screen.dart';
import 'package:perkup_vendor_app/screens/area/area_form_screen.dart';

class AreaListScreen extends StatelessWidget {
  const AreaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final areaProvider = Provider.of<AreaProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // Call fetchAreas on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = loginProvider.token;
      if (token != null) {
        areaProvider.fetchAreas(token);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Areas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AreaFormScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<AreaProvider>(
        builder: (context, areaProvider, child) {
          if (areaProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (areaProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'An error occurred: ${areaProvider.errorMessage}',
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
                        areaProvider.fetchAreas(token);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (areaProvider.areas.isEmpty) {
            return const Center(
              child: Text("No Data ATM"),
            );
          }

          return ListView.builder(
            itemCount: areaProvider.areas.length,
            itemBuilder: (context, index) {
              final area = areaProvider.areas[index];
              return ListTile(
                title: Text(area.areaName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AreaDetailScreen(areaID: area.areaID),
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
