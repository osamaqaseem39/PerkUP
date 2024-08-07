import 'package:flutter/material.dart';
import 'package:perkup_admin_app/models/login/login_response.dart';
import 'package:perkup_admin_app/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:perkup_admin_app/models/city/city.dart';
import 'package:perkup_admin_app/providers/city_provider.dart';
import 'package:perkup_admin_app/models/country/country.dart'; // Import the Country model
import 'package:perkup_admin_app/providers/country_provider.dart'; // Import the CountryProvider

class CityFormScreen extends StatefulWidget {
  final City? city;

  const CityFormScreen({super.key, this.city});

  @override
  // ignore: library_private_types_in_public_api
  _CityFormScreenState createState() => _CityFormScreenState();
}

class _CityFormScreenState extends State<CityFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _cityName;
  int? _countryID; // Make _countryID nullable to handle uninitialized state

  @override
  void initState() {
    super.initState();
    if (widget.city != null) {
      _cityName = widget.city!.cityName;
      _countryID = widget.city!.countryID;
    } else {
      _cityName = '';
      _countryID = null;
    }
    // Fetch countries on initialization
    final token = Provider.of<LoginProvider>(context, listen: false).token;
    Provider.of<CountryProvider>(context, listen: false).fetchCountries(token!);
  }

  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<CityProvider>(context);
    final token = Provider.of<LoginProvider>(context, listen: false).token;
    final countryProvider = Provider.of<CountryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.city == null ? 'New City' : 'Edit City'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _cityName,
                decoration: const InputDecoration(labelText: 'City Name'),
                onSaved: (value) => _cityName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a city name' : null,
              ),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Country'),
                value: _countryID,
                items: countryProvider.countries.map((Country country) {
                  return DropdownMenuItem<int>(
                    value: country.countryID,
                    child: Text(country.countryName),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _countryID = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a country' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  LoginResponse? user =
                      await LoginResponse.loadFromPreferences();

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final city = City(
                      cityID: widget.city?.cityID ?? 0,
                      cityName: _cityName,
                      countryID: _countryID!,
                      createdBy: user!.userId,
                      createdAt:
                          DateTime.now().toString().replaceFirst(" ", "T"),
                      updatedBy: user.userId,
                      updatedAt:
                          DateTime.now().toString().replaceFirst(" ", "T"),
                    );
                    if (widget.city == null) {
                      await cityProvider.createCity(city, token!);
                    } else {
                      await cityProvider.updateCity(city, token!);
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.city == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
