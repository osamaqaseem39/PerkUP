import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_user_app/providers/login_provider.dart';
import 'package:perkup_user_app/providers/city_provider.dart';
import 'package:perkup_user_app/screens/city/city_detail_screen.dart';
import 'package:perkup_user_app/screens/city/city_form_screen.dart';

class CityListScreen extends StatelessWidget {
  const CityListScreen({super.key});

  get country => null;

  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<CityProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // Call fetchCities on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = loginProvider.token;
      cityProvider
          .fetchCities(token!); // Ensure you pass the required arguments
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CityFormScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<CityProvider>(
        builder: (context, cityProvider, child) {
          if (cityProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (cityProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'An error occurred: ${cityProvider.errorMessage}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final token =
                          Provider.of<LoginProvider>(context, listen: false)
                              .token;
                      cityProvider.fetchCities(
                          token!); // Ensure you pass the required arguments
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (cityProvider.cities.isEmpty) {
            return const Center(child: Text("No Data ATM"));
          }

          return ListView.builder(
            itemCount: cityProvider.cities.length,
            itemBuilder: (context, index) {
              final city = cityProvider.cities[index];
              return ListTile(
                title: Text(city.cityName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CityDetailScreen(cityID: city.cityID),
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
