import 'package:flutter/foundation.dart';
import 'package:perkup_customer_app/services/menu_service.dart'; // Update this import as needed
import 'package:perkup_customer_app/models/menu/menu.dart';

class MenuProvider with ChangeNotifier {
  final MenuService _menuService = MenuService(); // Ensure this is defined

  List<Menu> _menus = [];
  List<Menu> get menus => _menus;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchMenusByCreatedBy(int createdBy, String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      _menus = await _menuService.fetchMenusByCreatedBy(createdBy, token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load menus. Please try again later.';
      _menus = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createMenu(Menu menu, String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _menuService.createMenu(menu, token);
      _menus.add(menu);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to create menu. Please try again later.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMenu(Menu menu, String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _menuService.updateMenu(menu, token);
      int index = _menus.indexWhere((m) => m.menuID == menu.menuID);
      if (index != -1) {
        _menus[index] = menu;
      }
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to update menu. Please try again later.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMenu(int id, String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _menuService.deleteMenu(id, token);
      _menus.removeWhere((menu) => menu.menuID == id);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to delete menu. Please try again later.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
