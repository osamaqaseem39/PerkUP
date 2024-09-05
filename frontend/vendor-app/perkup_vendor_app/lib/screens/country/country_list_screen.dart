import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_vendor_app/providers/login_provider.dart';
import 'package:perkup_vendor_app/providers/country_provider.dart';
import 'package:perkup_vendor_app/screens/country/country_detail_screen.dart';
import 'package:perkup_vendor_app/screens/country/country_form_screen.dart';

class CountryListScreen extends StatelessWidget {
  const CountryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final countryProvider =
        Provider.of<CountryProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // Call fetchCountries on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = loginProvider.token;
      countryProvider.fetchCountries(token!);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CountryFormScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<CountryProvider>(
        builder: (context, countryProvider, child) {
          if (countryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (countryProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'An error occurred: ${countryProvider.errorMessage}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final token =
                          Provider.of<LoginProvider>(context, listen: false)
                              .token;
                      countryProvider.fetchCountries(token!);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (countryProvider.countries.isEmpty) {
            return const Text("No Data ATM");
          }

          return ListView.builder(
            itemCount: countryProvider.countries.length,
            itemBuilder: (context, index) {
              final country = countryProvider.countries[index];
              return ListTile(
                title: Text(country.countryName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CountryDetailScreen(countryID: country.countryID),
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
