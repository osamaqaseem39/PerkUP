import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:perkup_admin_app/models/address/address.dart';
import 'package:perkup_admin_app/providers/address_provider.dart';

class AddressDropdown extends StatefulWidget {
  final String token;
  final dynamic? initialAddress;
  final Function(Address) onAddressSelected;

  const AddressDropdown({
    super.key,
    required this.token,
    this.initialAddress,
    required this.onAddressSelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddressDropdownState createState() => _AddressDropdownState();
}

class _AddressDropdownState extends State<AddressDropdown> {
  dynamic? _selectedAddress;
  Address? _selectedAddressValue;
  @override
  void initState() {
    super.initState();
    _selectedAddress = widget.initialAddress;
    _fetchAddresses();
  }

  void _fetchAddresses() async {
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);
    await addressProvider.fetchAddresses(widget.token);
    if (_selectedAddress != null) {
      if (addressProvider.addresses
          .where((element) => element.addressID == _selectedAddress)
          .isNotEmpty) {
        _selectedAddressValue = addressProvider.addresses
            .where((element) => element.addressID == _selectedAddress)
            .first;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressProvider>(
      builder: (context, addressProvider, child) {
        if (addressProvider.isLoading) {
          return const CircularProgressIndicator();
        } else if (addressProvider.errorMessage != null) {
          return Text('Error: ${addressProvider.errorMessage}');
        } else {
          return DropdownButton<Address>(
            value: _selectedAddressValue,
            hint: const Text('Select an address'),
            items: addressProvider.addresses.map((Address address) {
              return DropdownMenuItem<Address>(
                value: address,
                child: Text(address.name),
              );
            }).toList(),
            onChanged: (Address? newValue) {
              if (newValue != null) {
                _selectedAddressValue = newValue;
                widget.onAddressSelected(newValue);
                setState(() {});
              }
            },
          );
        }
      },
    );
  }
}
