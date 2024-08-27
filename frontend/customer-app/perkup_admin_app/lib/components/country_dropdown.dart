import 'package:flutter/material.dart';
import 'package:perkup_user_app/models/country/country.dart';
import 'package:perkup_user_app/providers/country_provider.dart';
import 'package:provider/provider.dart';

class CountryDropdown extends StatelessWidget {
  final String token;
  final Country? initialCountry;
  final Function(Country) onCountrySelected;

  const CountryDropdown({
    super.key,
    required this.token,
    required this.onCountrySelected,
    this.initialCountry,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CountryProvider()..fetchCountries(token),
      child: Consumer<CountryProvider>(
        builder: (context, countryProvider, child) {
          if (countryProvider.isLoading) {
            return const CircularProgressIndicator();
          } else if (countryProvider.errorMessage != null) {
            return Text('Error: ${countryProvider.errorMessage}');
          } else {
            return DropdownButton<Country>(
              value: initialCountry,
              hint: const Text('Select a Country'),
              onChanged: (Country? newValue) {
                if (newValue != null) {
                  onCountrySelected(newValue);
                }
              },
              items: countryProvider.countries
                  .map<DropdownMenuItem<Country>>((Country country) {
                return DropdownMenuItem<Country>(
                  value: country,
                  child: Text(country.countryName),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
