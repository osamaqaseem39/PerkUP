import 'package:flutter/material.dart';
import 'package:perkup_vendor_app/models/login/login_response.dart';
import 'package:perkup_vendor_app/services/api_service.dart';

class LoginProvider extends ChangeNotifier {
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final ApiService _apiService = ApiService();

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    final loginResponse = await _apiService.login(username, password);

    if (loginResponse != null && loginResponse.token.isNotEmpty) {
      _token = loginResponse.token;
      await LoginResponse.saveToPreferences(loginResponse);
      _errorMessage = null;
    } else {
      _errorMessage = 'Login failed';
    }

    _isLoading = false;
    notifyListeners();
  }
}
