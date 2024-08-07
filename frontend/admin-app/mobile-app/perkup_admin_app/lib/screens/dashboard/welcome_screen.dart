import 'package:flutter/material.dart';
import 'package:perkup_admin_app/screens/address/address_list_screen.dart';
import 'package:perkup_admin_app/screens/area/area_list_screen.dart';
import 'package:perkup_admin_app/screens/city/city_list_screen.dart';
import 'package:perkup_admin_app/screens/country/country_list_screen.dart';
import 'package:perkup_admin_app/screens/perk/perk_list_screen.dart';
import 'package:perkup_admin_app/screens/perktype/perktype_list_screen.dart';
import 'package:perkup_admin_app/screens/user/user_list_screen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key}); // Remove `const` here

  final List<Map<String, dynamic>> _actions = [
    {
      'icon': Icons.location_on,
      'label': 'Manage Addresses',
      'screen': const AddressListScreen(),
    },
    {
      'icon': Icons.map,
      'label': 'Manage Areas',
      'screen': const AreaListScreen(),
    },
    {
      'icon': Icons.location_city,
      'label': 'Manage Cities',
      'screen': const CityListScreen(),
    },
    {
      'icon': Icons.public,
      'label': 'Manage Countries',
      'screen': const CountryListScreen(),
    },
    {
      'icon': Icons.people,
      'label': 'Manage Users',
      'screen': const UserListScreen(),
    },
    {
      'icon': Icons.handshake,
      'label': 'Manage Perk Types',
      'screen': const PerkTypeListScreen(),
    },
    {
      'icon': Icons.handshake,
      'label': 'Manage Perk',
      'screen': const PerkListScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Admin App'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 10,
          ),
          itemCount: _actions.length,
          itemBuilder: (context, index) {
            final action = _actions[index];
            return ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => action['screen'],
                  ),
                );
              },
              icon: Icon(action['icon'], color: Colors.white),
              label: Text(
                action['label'],
                style: const TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                fixedSize: MaterialStateProperty.all<Size>(const Size(200, 80)),
                elevation: MaterialStateProperty.all<double>(3),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
