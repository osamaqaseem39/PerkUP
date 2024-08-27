import 'package:flutter/material.dart';
import 'package:perkup_user_app/models/area/area.dart';
import 'package:perkup_user_app/models/login/login_response.dart';
import 'package:perkup_user_app/providers/area_provider.dart';
import 'package:perkup_user_app/providers/city_provider.dart'; // Import CityProvider
import 'package:perkup_user_app/providers/login_provider.dart';
import 'package:perkup_user_app/models/city/city.dart'; // Import City model
import 'package:provider/provider.dart';

class AreaFormScreen extends StatefulWidget {
  final Area? area;

  const AreaFormScreen({super.key, this.area});

  @override
  // ignore: library_private_types_in_public_api
  _AreaFormScreenState createState() => _AreaFormScreenState();
}

class _AreaFormScreenState extends State<AreaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _areaName;
  int? _cityID;

  @override
  void initState() {
    super.initState();
    if (widget.area != null) {
      _areaName = widget.area!.areaName;
      _cityID = widget.area!.cityID;
    }
    // Fetch cities on initialization
    final token = Provider.of<LoginProvider>(context, listen: false).token;
    Provider.of<CityProvider>(context, listen: false).fetchCities(token!);
  }

  @override
  Widget build(BuildContext context) {
    final areaProvider = Provider.of<AreaProvider>(context);
    final token = Provider.of<LoginProvider>(context, listen: false).token;
    final cityProvider = Provider.of<CityProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.area == null ? 'New Area' : 'Edit Area'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: widget.area?.areaName,
                decoration: const InputDecoration(labelText: 'Area Name'),
                onSaved: (value) => _areaName = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter an area name' : null,
              ),
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'City'),
                value: _cityID,
                items: cityProvider.cities.map((City city) {
                  return DropdownMenuItem<int>(
                    value: city.cityID,
                    child: Text(city.cityName),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _cityID = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a city' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  LoginResponse? user =
                      await LoginResponse.loadFromPreferences();

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final area = Area(
                      areaID: widget.area?.areaID ?? 0,
                      areaName: _areaName,
                      cityID: _cityID!,
                      createdBy: user!.userId,
                      createdAt:
                          DateTime.now().toString().replaceFirst(" ", "T"),
                      updatedBy: user.userId,
                      updatedAt:
                          DateTime.now().toString().replaceFirst(" ", "T"),
                    );
                    if (widget.area == null) {
                      areaProvider.createArea(area, token!);
                    } else {
                      areaProvider.updateArea(area, token!);
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.area == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
