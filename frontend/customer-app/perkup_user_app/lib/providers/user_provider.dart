import 'package:flutter/material.dart';
import 'package:perkup_admin_app/models/user/user.dart';
import 'package:perkup_admin_app/services/user_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final UserService _userService = UserService();

  Future<void> fetchUsers(String token) async {
    _isLoading = true;
    _errorMessage = null; // Reset error message before fetching
    notifyListeners();

    try {
      _users = await _userService.fetchUsers(token);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createUser(User user, String token) async {
    _isLoading = true;
    _errorMessage = null; // Reset error message before creating
    notifyListeners();

    try {
      await _userService.createUser(user, token);
      await fetchUsers(token); // Refresh the user list
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(User user, String token) async {
    _isLoading = true;
    _errorMessage = null; // Reset error message before updating
    notifyListeners();

    try {
      await _userService.updateUser(user, token);
      await fetchUsers(token); // Refresh the user list
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteUser(int id, String token) async {
    _isLoading = true;
    _errorMessage = null; // Reset error message before deleting
    notifyListeners();

    try {
      await _userService.deleteUser(id, token);
      await fetchUsers(token); // Refresh the user list
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
