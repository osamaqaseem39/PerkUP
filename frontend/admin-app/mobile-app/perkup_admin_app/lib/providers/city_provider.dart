import 'package:flutter/material.dart';
import 'package:perkup_admin_app/models/city/city.dart'; // Import the City model
import 'package:perkup_admin_app/models/country/country.dart';
import 'package:perkup_admin_app/services/city_service.dart'; // Import the City service

class CityProvider extends ChangeNotifier {
  List<City> _cities = []; // Add a list for cities
  bool _isLoading = false;
  String? _errorMessage;

  List<City> get cities => _cities; // Getter for cities
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final CityService _cityService = CityService();

  List<Country>? get countries => null; // Initialize CityService

  // Fetch cities
  Future<void> fetchCities(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      _cities = await _cityService.fetchCities(token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Create city
  Future<void> createCity(City city, String token) async {
    try {
      await _cityService.createCity(city, token);
      await fetchCities(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Update city
  Future<void> updateCity(City city, String token) async {
    try {
      await _cityService.updateCity(city, token);
      await fetchCities(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Delete city
  Future<void> deleteCity(int id, String token) async {
    try {
      await _cityService.deleteCity(id, token);
      await fetchCities(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
