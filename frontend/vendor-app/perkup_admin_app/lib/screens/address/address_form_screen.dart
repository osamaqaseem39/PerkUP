import 'package:flutter/material.dart';
import 'package:perkup_admin_app/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:perkup_admin_app/models/login/login_response.dart';
import 'package:perkup_admin_app/providers/address_provider.dart';
import 'package:perkup_admin_app/providers/country_provider.dart';
import 'package:perkup_admin_app/providers/city_provider.dart';
import 'package:perkup_admin_app/providers/area_provider.dart';
import 'package:perkup_admin_app/models/address/address.dart';

class AddressFormScreen extends StatefulWidget {
  final Address? address;

  const AddressFormScreen({super.key, this.address});

  @override
  // ignore: library_private_types_in_public_api
  _AddressFormScreenState createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _street;
  late String _area;
  late String _city;
  int _areaID = 0;
  int _cityID = 0;
  late String _state;
  late String _postalCode;
  late String _country;
  int _countryID = 0;
  late double _latitude;
  late double _longitude;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _name = widget.address!.name;
      _street = widget.address!.street;
      _area = widget.address!.area;
      _city = widget.address!.city;
      _state = widget.address!.state;
      _postalCode = widget.address!.postalCode;
      _country = widget.address!.country;
      _latitude = widget.address!.latitude!;
      _longitude = widget.address!.longitude!;
    } else {
      _areaID = 0;
      _cityID = 0;
      _countryID = 0;
      _name = '';
      _street = '';
      _area = '';
      _city = '';
      _state = '';
      _postalCode = '';
      _country = '';
      _latitude = 0;
      _longitude = 0;
    }

    final token = Provider.of<LoginProvider>(context, listen: false).token;
    Provider.of<CountryProvider>(context, listen: false).fetchCountries(token!);
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final countryProvider = Provider.of<CountryProvider>(context);
    final cityProvider = Provider.of<CityProvider>(context);
    final areaProvider = Provider.of<AreaProvider>(context);
    final token = Provider.of<LoginProvider>(context, listen: false).token;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'New Address' : 'Edit Address'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _name,
                  decoration: const InputDecoration(labelText: 'Name'),
                  onSaved: (value) => _name = value!,
                  validator: (value) => value!.isEmpty ? 'Enter a Name' : null,
                ),
                TextFormField(
                  initialValue: _street,
                  decoration: const InputDecoration(labelText: 'Street'),
                  onSaved: (value) => _street = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a street' : null,
                ),
                TextFormField(
                  initialValue: _state,
                  decoration: const InputDecoration(labelText: 'State'),
                  onSaved: (value) => _state = value!,
                  validator: (value) => value!.isEmpty ? 'Enter a state' : null,
                ),
                TextFormField(
                  initialValue: _postalCode,
                  decoration: const InputDecoration(labelText: 'Postal Code'),
                  onSaved: (value) => _postalCode = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a postal code' : null,
                ),
                TextFormField(
                  initialValue: _latitude.toString(),
                  decoration: const InputDecoration(labelText: 'Latitude'),
                  onSaved: (value) => _latitude = double.parse(value!),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a latitude' : null,
                ),
                TextFormField(
                  initialValue: _longitude.toString(),
                  decoration: const InputDecoration(labelText: 'Longitude'),
                  onSaved: (value) => _longitude = double.parse(value!),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a longitude' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _country.isEmpty ? null : _country,
                  onChanged: (value) async {
                    setState(() {
                      _country = value!;
                      _countryID = countryProvider.countries
                          .where((element) => element.countryName == value)
                          .first
                          .countryID;
                      _city = '';
                      _area = '';
                    });
                    // Fetch cities based on selected country
                    await cityProvider.fetchCities(token!);
                  },
                  items: countryProvider.countries.map((country) {
                    return DropdownMenuItem<String>(
                      value: country.countryName, // Use country name as value
                      child: Text(country.countryName),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Select Country',
                    border: OutlineInputBorder(),
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _city.isEmpty ? null : _city,
                  onChanged: (value) async {
                    setState(() {
                      _city = value!;

                      _cityID = cityProvider.cities
                          .where((element) => element.cityName == value)
                          .first
                          .cityID;
                      _area = '';
                    });
                    // Fetch areas based on selected city
                    await areaProvider.fetchAreas(token!);
                  },
                  items: cityProvider.cities.map((city) {
                    return DropdownMenuItem<String>(
                      value: city.cityName, // Use city name as value
                      child: Text(city.cityName),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Select City',
                    border: OutlineInputBorder(),
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _area.isEmpty ? null : _area,
                  onChanged: (value) {
                    setState(() {
                      _area = value!;

                      _areaID = areaProvider.areas
                          .where((element) => element.areaName == value)
                          .first
                          .areaID;
                    });
                  },
                  items: areaProvider.areas.map((area) {
                    return DropdownMenuItem<String>(
                      value: area.areaName, // Use area name as value
                      child: Text(area.areaName),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Select Area',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      LoginResponse? user =
                          await LoginResponse.loadFromPreferences();

                      final address = Address(
                          addressID: widget.address?.addressID ?? 0,
                          name: _name,
                          street: _street,
                          areaID: _areaID,
                          cityID: _cityID,
                          state: _state,
                          postalCode: _postalCode,
                          country: _country,
                          countryID: _countryID,
                          area: _area,
                          city: _city,
                          latitude: _latitude,
                          longitude: _longitude,
                          createdBy: user!.userId,
                          createdAt:
                              DateTime.now().toString().replaceFirst(" ", "T"),
                          updatedBy: user.userId,
                          updatedAt:
                              DateTime.now().toString().replaceFirst(" ", "T"));
                      if (widget.address == null) {
                        await addressProvider.createAddress(address, token!);
                      } else {
                        await addressProvider.updateAddress(address, token!);
                      }

                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(widget.address == null ? 'Create' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
