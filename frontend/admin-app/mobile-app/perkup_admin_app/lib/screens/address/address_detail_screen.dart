import 'package:flutter/material.dart';
import 'package:perkup_admin_app/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:perkup_admin_app/providers/address_provider.dart';
import 'package:perkup_admin_app/screens/address/address_form_screen.dart';

class AddressDetailScreen extends StatelessWidget {
  final int addressID;
  const AddressDetailScreen({super.key, required this.addressID});

  @override
  Widget build(BuildContext context) {
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    final token = Provider.of<LoginProvider>(context, listen: false).token;
    final address = addressProvider.addresses
        .firstWhere((addr) => addr.addressID == addressID);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddressFormScreen(address: address),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              bool? deleteConfirmed = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete Address'),
                    content: const Text(
                        'Are you sure you want to delete this address?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );

              if (deleteConfirmed == true) {
                await addressProvider.deleteAddress(addressID, token!);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Street: ${address.street}'),
            Text('City: ${address.city}'),
            Text('State: ${address.state}'),
            Text('Postal Code: ${address.postalCode}'),
            Text('Country: ${address.country}'),
            Text('Latitude: ${address.latitude}'),
            Text('Longitude: ${address.longitude}'),
            Text('Created By: ${address.createdBy}'),
            Text('Created At: ${address.createdAt}'),
            Text('Updated By: ${address.updatedBy}'),
            Text('Updated At: ${address.updatedAt}'),
          ],
        ),
      ),
    );
  }
}
