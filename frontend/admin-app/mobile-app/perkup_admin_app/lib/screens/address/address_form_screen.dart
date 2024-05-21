import 'package:flutter/material.dart';
import 'package:perkup_admin_app/models/login/login_response.dart';
import 'package:perkup_admin_app/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:perkup_admin_app/models/address/address.dart';
import 'package:perkup_admin_app/providers/address_provider.dart';

class AddressFormScreen extends StatefulWidget {
  final Address? address;

  const AddressFormScreen({super.key, this.address});

  @override
  // ignore: library_private_types_in_public_api
  _AddressFormScreenState createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _street;
  late String _city;
  late String _state;
  late String _postalCode;
  late String _country;
  late int _latitude;
  late int _longitude;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _street = widget.address!.street;
      _city = widget.address!.city;
      _state = widget.address!.state;
      _postalCode = widget.address!.postalCode;
      _country = widget.address!.country;
      _latitude = widget.address!.latitude;
      _longitude = widget.address!.longitude;
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProvider>(context);
    final token = Provider.of<LoginProvider>(context, listen: false).token;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'New Address' : 'Edit Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.address?.street,
                decoration: const InputDecoration(labelText: 'Street'),
                onSaved: (value) => _street = value!,
                validator: (value) => value!.isEmpty ? 'Enter a street' : null,
              ),
              TextFormField(
                initialValue: widget.address?.city,
                decoration: const InputDecoration(labelText: 'City'),
                onSaved: (value) => _city = value!,
                validator: (value) => value!.isEmpty ? 'Enter a city' : null,
              ),
              TextFormField(
                initialValue: widget.address?.state,
                decoration: const InputDecoration(labelText: 'State'),
                onSaved: (value) => _state = value!,
                validator: (value) => value!.isEmpty ? 'Enter a state' : null,
              ),
              TextFormField(
                initialValue: widget.address?.postalCode,
                decoration: const InputDecoration(labelText: 'Postal Code'),
                onSaved: (value) => _postalCode = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter a postal code' : null,
              ),
              TextFormField(
                initialValue: widget.address?.country,
                decoration: const InputDecoration(labelText: 'Country'),
                onSaved: (value) => _country = value!,
                validator: (value) => value!.isEmpty ? 'Enter a country' : null,
              ),
              TextFormField(
                initialValue: widget.address?.latitude.toString(),
                decoration: const InputDecoration(labelText: 'Latitude'),
                onSaved: (value) => _latitude = int.parse(value!),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a latitude' : null,
              ),
              TextFormField(
                initialValue: widget.address?.longitude.toString(),
                decoration: const InputDecoration(labelText: 'Longitude'),
                onSaved: (value) => _longitude = int.parse(value!),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a longitude' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  LoginResponse? user =
                      await LoginResponse.loadFromPreferences();

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final address = Address(
                        addressID: widget.address?.addressID ?? 0,
                        street: _street,
                        city: _city,
                        state: _state,
                        postalCode: _postalCode,
                        country: _country,
                        latitude: _latitude,
                        longitude: _longitude,
                        createdBy: user!
                            .userId, // Replace with the actual createdBy value
                        createdAt: DateTime.now().toString().replaceFirst(" ",
                            "T"), // Replace with the actual createdAt value
                        updatedBy: user
                            .userId, // Replace with the actual updatedBy value
                        updatedAt: DateTime.now().toString().replaceFirst(
                            " ", "T") // Replace with the actual updatedAt value
                        );
                    if (widget.address == null) {
                      addressProvider.createAddress(address, token!);
                    } else {
                      addressProvider.updateAddress(address, token!);
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
    );
  }
}
