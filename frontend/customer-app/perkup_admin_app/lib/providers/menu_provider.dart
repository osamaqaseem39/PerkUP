import 'package:flutter/material.dart';
import 'package:perkup_user_app/models/menu/menu.dart';
import 'package:perkup_user_app/services/menu_service.dart'; // Ensure this is the correct path
// Adjust if the path is different

class MenuProvider with ChangeNotifier {
  List<Menu> _menus = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Menu> get menus => _menus;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final MenuService _menuService = MenuService();

  Future<void> fetchMenus(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      _menus = await _menuService.fetchMenus(token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createMenu(Menu menu, String token) async {
    try {
      await _menuService.createMenu(menu, token);
      await fetchMenus(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateMenu(Menu menu, String token) async {
    try {
      await _menuService.updateMenu(menu, token);
      await fetchMenus(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteMenu(int id, String token) async {
    try {
      await _menuService.deleteMenu(id, token);
      await fetchMenus(token);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
