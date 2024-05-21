import 'package:flutter/material.dart';
import 'package:perkup_admin_app/models/address/address.dart';
import 'package:perkup_admin_app/services/address_service.dart';

class AddressProvider extends ChangeNotifier {
  List<Address> _addresses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Address> get addresses => _addresses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final AddressService _addressService = AddressService();

  Future<void> fetchAddresses(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      _addresses = await _addressService.fetchAddresses(token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createAddress(Address address, String token) async {
    try {
      await _addressService.createAddress(address, token);
      await fetchAddresses(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateAddress(Address address, String token) async {
    try {
      await _addressService.updateAddress(address, token);
      await fetchAddresses(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteAddress(int id, String token) async {
    try {
      await _addressService.deleteAddress(id, token);
      await fetchAddresses(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
