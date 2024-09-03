import 'package:flutter/material.dart';
import 'package:perkup_user_app/models/menu/menu.dart';
import 'package:perkup_user_app/services/menu_service.dart'; // Ensure this is the correct path

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
    _setLoading(true);
    try {
      _menus = await _menuService.fetchMenus(token);
      _clearError();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Create a new menu
  Future<void> createMenu(Menu menu, String token) async {
    _setLoading(true);
    try {
      await _menuService.createMenu(menu, token);
      await fetchMenus(token); // Refresh menus after creation
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing menu
  Future<void> updateMenu(Menu menu, String token) async {
    _setLoading(true);
    try {
      await _menuService.updateMenu(menu, token);
      await fetchMenus(token); // Refresh menus after update
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Delete a menu
  Future<void> deleteMenu(int id, String token) async {
    _setLoading(true);
    try {
      await _menuService.deleteMenu(id, token);
      await fetchMenus(token); // Refresh menus after deletion
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Add a new menu to the local list without fetching from the server
  void addMenu(Menu menu, String token) {
    _menus.add(menu);
    notifyListeners();
  }

  // Select a menu
  void selectMenu(Menu menu) {
    _selectedMenu = menu;
    notifyListeners();
  }

  // Deselect the currently selected menu
  void deselectMenu() {
    _selectedMenu = null;
    notifyListeners();
  }

  // Set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Set error message
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  // Clear error message
  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setErrorMessage(String s) {}
}
