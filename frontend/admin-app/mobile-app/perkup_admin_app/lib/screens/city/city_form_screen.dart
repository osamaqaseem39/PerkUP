import 'package:flutter/material.dart';
import 'package:perkup_admin_app/models/login/login_response.dart';
import 'package:perkup_admin_app/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:perkup_admin_app/models/city/city.dart';
import 'package:perkup_admin_app/providers/city_provider.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart'; // Import the autocomplete_textfield package
import 'package:perkup_admin_app/models/country/country.dart'; // Import the Country model

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
  late int _countryID; // Added countryID
  late List<Country> _countries; // Added list of countries
  late AutoCompleteTextField<Country>
      _countryTextField; // Added AutoCompleteTextField

  @override
  void initState() {
    super.initState();
    _countries = Provider.of<CityProvider>(context, listen: false).countries!;
    if (widget.city != null) {
      _cityName = widget.city!.cityName;
      _countryID = widget.city!.countryID;
    }
    _countryTextField = AutoCompleteTextField<Country>(
      key: GlobalKey(),
      clearOnSubmit: false,
      suggestions: _countries,
      style: const TextStyle(color: Colors.black),
      decoration: const InputDecoration(labelText: 'Country'),
      itemFilter: (item, query) =>
          item.countryName.toLowerCase().startsWith(query.toLowerCase()),
      itemSorter: (a, b) => a.countryName.compareTo(b.countryName),
      itemSubmitted: (item) {
        setState(() {
          _countryTextField.textField?.controller!.text = item.countryName;
          _countryID = item.countryID;
        });
      },
      itemBuilder: (context, item) => ListTile(
        title: Text(item.countryName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<CityProvider>(context);
    final token = Provider.of<LoginProvider>(context, listen: false).token;

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
                initialValue: widget.city?.cityName,
                decoration: const InputDecoration(labelText: 'City Name'),
                onSaved: (value) => _cityName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a city name' : null,
              ),
              _countryTextField, // Use the AutoCompleteTextField for country
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
                      countryID: _countryID,
                      createdBy: user!.userId,
                      createdAt:
                          DateTime.now().toString().replaceFirst(" ", "T"),
                      updatedBy: user.userId,
                      updatedAt:
                          DateTime.now().toString().replaceFirst(" ", "T"),
                    );
                    if (widget.city == null) {
                      cityProvider.createCity(city, token!);
                    } else {
                      cityProvider.updateCity(city, token!);
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
