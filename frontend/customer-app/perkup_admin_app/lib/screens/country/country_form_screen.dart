import 'package:flutter/material.dart';
import 'package:perkup_user_app/models/login/login_response.dart';
import 'package:perkup_user_app/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:perkup_user_app/models/country/country.dart';
import 'package:perkup_user_app/providers/country_provider.dart';

class CountryFormScreen extends StatefulWidget {
  final Country? country;

  const CountryFormScreen({super.key, this.country});

  @override
  // ignore: library_private_types_in_public_api
  _CountryFormScreenState createState() => _CountryFormScreenState();
}

class _CountryFormScreenState extends State<CountryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _countryName;

  @override
  void initState() {
    super.initState();
    if (widget.country != null) {
      _countryName = widget.country!.countryName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final countryProvider = Provider.of<CountryProvider>(context);
    final token = Provider.of<LoginProvider>(context, listen: false).token;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country == null ? 'New Country' : 'Edit Country'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.country?.countryName,
                decoration: const InputDecoration(labelText: 'Country Name'),
                onSaved: (value) => _countryName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a country name' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  LoginResponse? user =
                      await LoginResponse.loadFromPreferences();

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final country = Country(
                        countryID: widget.country?.countryID ?? 0,
                        countryName: _countryName,
                        createdBy: user!
                            .userId, // Replace with the actual createdBy value
                        createdAt: DateTime.now().toString().replaceFirst(" ",
                            "T"), // Replace with the actual createdAt value
                        updatedBy: user
                            .userId, // Replace with the actual updatedBy value
                        updatedAt: DateTime.now().toString().replaceFirst(
                            " ", "T") // Replace with the actual updatedAt value
                        );
                    if (widget.country == null) {
                      countryProvider.createCountry(country, token!);
                    } else {
                      countryProvider.updateCountry(country, token!);
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.country == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
