import 'package:flutter/material.dart';
import 'package:perkup_vendor_app/models/menu/menu.dart';
import 'package:perkup_vendor_app/services/menu_service.dart'; // Ensure this is the correct path

class MenuProvider with ChangeNotifier {
  List<Menu> _menus = [];
  bool _isLoading = false;
  String? _errorMessage;
  Menu? _selectedMenu;

  // Service to handle API requests
  final MenuService _menuService = MenuService();

  // Getters for accessing private variables
  List<Menu> get menus => _menus;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Menu? get selectedMenu => _selectedMenu;

  // Fetch all menus from the server
  Future<void> fetchMenus(String token) async {
    print('Fetching menus...'); // Debug statement
    _setLoading(true);
    try {
      _menus = await _menuService.fetchMenus(token);
      _clearError();
      print('Menus fetched successfully: $_menus'); // Debug statement
    } catch (e) {
      print('Error fetching menus: $e'); // Debug statement
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Create a new menu
  Future<void> createMenu(Menu menu, String token) async {
    print('Creating menu: ${menu.toJson()}'); // Debug statement
    _setLoading(true);
    try {
      await _menuService.createMenu(menu, token);
      await fetchMenus(token); // Refresh menus after creation
      print('Menu created successfully'); // Debug statement
    } catch (e) {
      print('Error creating menu: $e'); // Debug statement
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing menu
  Future<void> updateMenu(Menu menu, String token) async {
    print('Updating menu with ID: ${menu.menuID}'); // Debug statement
    _setLoading(true);
    try {
      await _menuService.updateMenu(menu, token);
      await fetchMenus(token); // Refresh menus after update
      print('Menu updated successfully'); // Debug statement
    } catch (e) {
      print('Error updating menu: $e'); // Debug statement
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Delete a menu
  Future<void> deleteMenu(int id, String token) async {
    print('Deleting menu with ID: $id'); // Debug statement
    _setLoading(true);
    try {
      await _menuService.deleteMenu(id, token);
      await fetchMenus(token); // Refresh menus after deletion
      print('Menu deleted successfully'); // Debug statement
    } catch (e) {
      print('Error deleting menu: $e'); // Debug statement
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Add a new menu to the local list without fetching from the server
  void addMenu(Menu menu, String token) {
    print('Adding menu locally: ${menu.toJson()}'); // Debug statement
    _menus.add(menu);
    notifyListeners();
    print('Menu added to local list: $_menus'); // Debug statement
  }

  // Select a menu
  void selectMenu(Menu menu) {
    print('Selecting menu: ${menu.toJson()}'); // Debug statement
    _selectedMenu = menu;
    notifyListeners();
  }

  // Deselect the currently selected menu
  void deselectMenu() {
    print('Deselecting menu'); // Debug statement
    _selectedMenu = null;
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool value) {
    print('Setting loading state to: $value'); // Debug statement
    _isLoading = value;
    notifyListeners();
  }

  // Set error message
  void _setError(String message) {
    print('Setting error message: $message'); // Debug statement
    _errorMessage = message;
    notifyListeners();
  }

  // Clear error message
  void _clearError() {
    print('Clearing error message'); // Debug statement
    _errorMessage = null;
    notifyListeners();
  }

  void setErrorMessage(String s) {}
}
