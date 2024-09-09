import 'package:flutter/material.dart';
import 'package:perkup_vendor_app/models/user/user.dart';
import 'package:perkup_vendor_app/services/user_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  final UserService _userService = UserService();

  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _userService.fetchUsers();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<User?> getUserById(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // try {
    // Fetch user details from the service
    _currentUser = await _userService.fetchUserById(id);
    print(_currentUser);
    return _currentUser; // Return the fetched user data
    // } catch (e) {
    //   _errorMessage = e.toString();
    //   return null; // Return null on error
    // } finally {
    //   _isLoading = false;
    //   notifyListeners();
    // }
  }

  Future<bool> createUser(User user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userService.createUser(user);
      await fetchUsers(); // Refresh the user list
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(User user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userService.updateUser(user);
      await fetchUsers(); // Refresh the user list
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteUser(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userService.deleteUser(id);
      await fetchUsers(); // Refresh the user list
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
