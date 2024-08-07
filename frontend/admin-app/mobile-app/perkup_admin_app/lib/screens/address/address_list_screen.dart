import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_admin_app/providers/login_provider.dart';
import 'package:perkup_admin_app/providers/address_provider.dart';
import 'package:perkup_admin_app/screens/address/address_detail_screen.dart';
import 'package:perkup_admin_app/screens/address/address_form_screen.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);

    // Call fetchAddresses on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = loginProvider.token;
      if (token != null) {
        addressProvider.fetchAddresses(token);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Addresses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddressFormScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          if (addressProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (addressProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'An error occurred: ${addressProvider.errorMessage}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      final token =
                          Provider.of<LoginProvider>(context, listen: false)
                              .token;
                      if (token != null) {
                        addressProvider.fetchAddresses(token);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (addressProvider.addresses.isEmpty) {
            return const Center(
              child: Text("No Data ATM"),
            );
          }

          return ListView.builder(
            itemCount: addressProvider.addresses.length,
            itemBuilder: (context, index) {
              final address = addressProvider.addresses[index];
              return ListTile(
                title: Text(address.street),
                subtitle: Text('${address.city}, ${address.state}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddressDetailScreen(addressID: address.addressID),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
