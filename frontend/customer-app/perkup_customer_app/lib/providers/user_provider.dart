import 'package:flutter/material.dart';
import 'package:perkup_customer_app/models/user/user.dart';
import 'package:perkup_customer_app/models/user/userbytype.dart';
import 'package:perkup_customer_app/services/user_service.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];
  List<UserByType> _userByType = [];
  bool _isLoading = false;
  String? _errorMessage;
  User? _currentUser;

  List<User> get users => _users;
  List<UserByType> get userByType => _userByType;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  final UserService _userService = UserService();

  // Fetch users by UserType
  Future<void> fetchUsersByType(String userType) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userByType = await _userService.fetchUsersByUserType(userType);
    } catch (e) {
      _errorMessage = _parseError(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _users = await _userService.fetchUsers();
    } catch (e) {
      _errorMessage = _parseError(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future createUser(User user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userService.createUser(user);
      await fetchUsers();
    } catch (e) {
      _errorMessage = _parseError(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future updateUser(User user) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userService.updateUser(user);
      await fetchUsers();
    } catch (e) {
      _errorMessage = _parseError(e);
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
      await fetchUsers();
    } catch (e) {
      _errorMessage = _parseError(e);
    }

    _isLoading = false;
    notifyListeners();
  }

  String _parseError(Object error) {
    // Customize error parsing based on your needs
    return error.toString();
  }
}
