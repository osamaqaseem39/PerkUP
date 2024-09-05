import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perkup_customer_app/models/menu/menu.dart';
import 'package:perkup_customer_app/models/menu/menuitem.dart';

class MenuService {
  final String baseUrl =
      'https://localhost:44320/api'; // Adjust the base URL as needed

  Future<List<Menu>> fetchMenusByCreatedBy(int createdBy, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Menus/GetMenusByCreatedBy/$createdBy'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      // Map to hold menus by ID for quick lookup
      Map<int, Menu> menuMap = {};
      List<Menu> menuList = [];

      // Process the list of menus
      for (var menuJson in jsonResponse) {
        Menu menu = Menu.fromJson(menuJson);
        menuMap[menu.menuID] = menu;
        menuList.add(menu);
      }

      // Process menu items and associate them with the menus
      for (var menuJson in jsonResponse) {
        var menuItemsJson = menuJson['menuItems']
            as List<dynamic>?; // Ensure 'menuItems' exists
        if (menuItemsJson != null) {
          Menu? menu = menuMap[menuJson['menuID']];
          if (menu != null) {
            menu.menuItems = menuItemsJson
                .map((itemJson) => MenuItem.fromJson(itemJson))
                .toList();
          }
        }
      }

      return menuList;
    } else {
      throw Exception('Failed to load menus by createdBy');
    }
  }

  Future<List<Menu>> fetchMenus(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/menus'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((menu) => Menu.fromJson(menu)).toList();
    } else {
      throw Exception('Failed to load menus');
    }
  }

  Future<void> createMenu(Menu menu, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/menus'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(menu.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create menu');
    }
  }

  Future<void> updateMenu(Menu menu, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/menus/${menu.menuID}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(menu.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update menu');
    }
  }

  Future<void> deleteMenu(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/menus/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete menu');
    }
  }
}
