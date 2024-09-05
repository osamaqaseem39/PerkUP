import 'package:flutter/material.dart';
import 'package:perkup_vendor_app/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:perkup_vendor_app/providers/country_provider.dart';
import 'package:perkup_vendor_app/screens/country/country_form_screen.dart';

class CountryDetailScreen extends StatelessWidget {
  final int countryID;
  const CountryDetailScreen({super.key, required this.countryID});

  @override
  Widget build(BuildContext context) {
    final countryProvider =
        Provider.of<CountryProvider>(context, listen: false);
    final token = Provider.of<LoginProvider>(context, listen: false).token;
    final country = countryProvider.countries
        .firstWhere((country) => country.countryID == countryID);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CountryFormScreen(country: country),
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
                    title: const Text('Delete Country'),
                    content: const Text(
                        'Are you sure you want to delete this country?'),
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
                await countryProvider.deleteCountry(countryID, token!);
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
            Text('Country ID: ${country.countryID}'),
            Text('Country Name: ${country.countryName}'),
            Text('Created By: ${country.createdBy}'),
            Text('Created At: ${country.createdAt}'),
            Text('Updated By: ${country.updatedBy}'),
            Text('Updated At: ${country.updatedAt}'),
          ],
        ),
      ),
    );
  }
}
