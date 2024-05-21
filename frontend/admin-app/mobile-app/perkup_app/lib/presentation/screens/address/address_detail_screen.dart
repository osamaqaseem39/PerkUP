import 'package:flutter/material.dart';
import 'package:perkup_app/data/models/address/address_model.dart';
import 'package:perkup_app/presentation/screens/address/add_edit_address_screen.dart'; // Import the Add/Edit screen
import 'package:perkup_app/data/repository/address/address_repository.dart'; // Import the AddressRepository

class AddressDetailScreen extends StatelessWidget {
  final Address address;
  final AddressRepository _addressRepository = AddressRepository(); // Instantiate the repository

  AddressDetailScreen({super.key, required this.address});

  void _deleteAddress(BuildContext context) async {
    try {
      await _addressRepository.deleteAddress(address.addressID);
      // ignore: use_build_context_synchronously
      Navigator.pop(context, 'deleted'); // Navigate back with a result
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to delete address')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Detail'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Street'),
            subtitle: Text(address.street),
          ),
          ListTile(
            title: const Text('City'),
            subtitle: Text(address.city),
          ),
          ListTile(
            title: const Text('State'),
            subtitle: Text(address.state),
          ),
          ListTile(
            title: const Text('Postal Code'),
            subtitle: Text(address.postalCode),
          ),
          ListTile(
            title: const Text('Country'),
            subtitle: Text(address.country),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to edit address screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddEditAddressScreen(address: address)),
                  );
                },
                child: const Text('Edit'),
              ),
              ElevatedButton(
                onPressed: () => _showDeleteConfirmationDialog(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Address'),
          content: const Text('Are you sure you want to delete this address?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteAddress(context); // Call the delete function
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
