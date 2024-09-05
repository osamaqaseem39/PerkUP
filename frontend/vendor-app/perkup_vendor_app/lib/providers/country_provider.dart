import 'package:flutter/material.dart';
import 'package:perkup_vendor_app/models/country/country.dart'; // Import the Country model
import 'package:perkup_vendor_app/services/country_service.dart'; // Import the Country service

class CountryProvider extends ChangeNotifier {
  List<Country> _countries = []; // Add a list for countries
  bool _isLoading = false;
  String? _errorMessage;

  List<Country> get countries => _countries; // Getter for countries
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final CountryService _countryService =
      CountryService(); // Initialize CountryService

  // Fetch countries
  Future<void> fetchCountries(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      _countries = await _countryService.fetchCountries(token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Create country
  Future<void> createCountry(Country country, String token) async {
    try {
      await _countryService.createCountry(country, token);
      await fetchCountries(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Update country
  Future<void> updateCountry(Country country, String token) async {
    try {
      await _countryService.updateCountry(country, token);
      await fetchCountries(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Delete country
  Future<void> deleteCountry(int id, String token) async {
    try {
      await _countryService.deleteCountry(id, token);
      await fetchCountries(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
