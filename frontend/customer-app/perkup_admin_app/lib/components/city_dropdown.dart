import 'package:flutter/material.dart';
import 'package:perkup_user_app/models/city/city.dart';
import 'package:perkup_user_app/providers/city_provider.dart';
import 'package:provider/provider.dart';

class CityDropdown extends StatelessWidget {
  final String token;
  final int countryID; // Added this to pass as the second argument
  final int? initialCityId;
  final Function(City) onCitySelected;

  const CityDropdown({
    super.key,
    required this.token,
    required this.countryID, // Added this to constructor
    required this.onCitySelected,
    this.initialCityId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          CityProvider()..fetchCities(token), // Passing both arguments
      child: Consumer<CityProvider>(
        builder: (context, cityProvider, child) {
          if (cityProvider.isLoading) {
            return const CircularProgressIndicator();
          } else if (cityProvider.errorMessage != null) {
            return Text('Error: ${cityProvider.errorMessage}');
          } else {
            return DropdownButton<int>(
              value: initialCityId,
              hint: const Text('Select a City'),
              onChanged: (int? newValue) async {
                if (newValue != null) {
                  City selectedCity =
                      await cityProvider.getCityById(newValue, token);
                  onCitySelected(selectedCity);
                }
              },
              items:
                  cityProvider.cities.map<DropdownMenuItem<int>>((City city) {
                return DropdownMenuItem<int>(
                  value: city.cityID,
                  child: Text(city.cityName),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
