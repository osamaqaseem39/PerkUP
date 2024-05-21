import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_app/data/models/address/address_model.dart';
import 'package:your_app/logic/bloc/Address/address_bloc.dart';
import 'package:your_app/logic/bloc/Address/address_event.dart';
import 'package:your_app/logic/bloc/Address/address_state.dart';

class AddEditAddressScreen extends StatefulWidget {
  final bool isEditing;
  final Address? address;

  const AddEditAddressScreen({Key? key, required this.isEditing, this.address})
      : super(key: key);

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postalCodeController;
  late TextEditingController _countryController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();
    _streetController = TextEditingController(text: widget.address?.street);
    _cityController = TextEditingController(text: widget.address?.city);
    _stateController = TextEditingController(text: widget.address?.state);
    _postalCodeController =
        TextEditingController(text: widget.address?.postalCode);
    _countryController = TextEditingController(text: widget.address?.country);
    _latitudeController = TextEditingController(
        text: widget.address?.latitude.toString());
    _longitudeController = TextEditingController(
        text: widget.address?.longitude.toString());
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Address' : 'Add Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: 'Street',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter street';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: 'State',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter state';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _postalCodeController,
                decoration: const InputDecoration(
                  labelText: 'Postal Code',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter postal code';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: 'Country',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter country';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _latitudeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Latitude',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter latitude';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid latitude';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _longitudeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Longitude',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter longitude';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid longitude';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final addressData = Address(
                      addressID: widget.address?.addressID ?? 0,
                      street: _streetController.text,
                      city: _cityController.text,
                      state: _stateController.text,
                      postalCode: _postalCodeController.text,
                      country: _countryController.text,
                      latitude: int.parse(_latitudeController.text), // Assuming integer latitudes
                      longitude: int.parse(_longitudeController.text), // Assuming integer longitudes
                      createdBy: 0, // Assuming this will be handled by API
                      createdAt: DateTime.now().toString(),
                      updatedBy: 0, // Assuming this will be handled by API
                      updatedAt: DateTime.now().toString(),
                    );

                    if (widget.isEditing) {
                      BlocProvider.of<AddressBloc>(context)
                          .add(UpdateAddressEvent(address: addressData));
                    } else {
                      BlocProvider.of<AddressBloc>(context)
                          .add(AddAddressEvent(address: addressData));
                    }
                  }
                },
                child: Text(widget.isEditing ? 'Update Address' : 'Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}