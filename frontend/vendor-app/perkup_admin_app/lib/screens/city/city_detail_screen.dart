import 'package:flutter/material.dart';
import 'package:perkup_admin_app/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:perkup_admin_app/providers/city_provider.dart';
import 'package:perkup_admin_app/screens/city/city_form_screen.dart';

class CityDetailScreen extends StatelessWidget {
  final int cityID;
  const CityDetailScreen({super.key, required this.cityID});

  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<CityProvider>(context, listen: false);
    final token = Provider.of<LoginProvider>(context, listen: false).token;
    final city =
        cityProvider.cities.firstWhere((city) => city.cityID == cityID);

    return Scaffold(
      appBar: AppBar(
        title: const Text('City Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CityFormScreen(city: city),
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
                    title: const Text('Delete City'),
                    content: const Text(
                        'Are you sure you want to delete this city?'),
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
                await cityProvider.deleteCity(cityID, token!);
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
            Text('City ID: ${city.cityID}'),
            Text('City Name: ${city.cityName}'),
            Text('Created By: ${city.createdBy}'),
            Text('Created At: ${city.createdAt}'),
            Text('Updated By: ${city.updatedBy}'),
            Text('Updated At: ${city.updatedAt}'),
          ],
        ),
      ),
    );
  }
}
