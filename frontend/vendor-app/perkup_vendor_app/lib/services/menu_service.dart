import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perkup_vendor_app/models/menu/menu.dart';

class MenuService {
  final String baseUrl =
      'https://192.168.10.18:7295/api'; // Adjust the base URL as needed

  Future<List<Menu>> fetchMenus(String token) async {
    print('Fetching menus...'); // Debug statement
    final response = await http.get(
      Uri.parse('$baseUrl/menus'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('Response status code: ${response.statusCode}'); // Debug statement
    print('Response body: ${response.body}'); // Debug statement

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      print('Fetched menus successfully'); // Debug statement
      return jsonResponse.map((menu) => Menu.fromJson(menu)).toList();
    } else {
      print('Failed to load menus'); // Debug statement
      throw Exception('Failed to load menus');
    }
  }

  Future<void> createMenu(Menu menu, String token) async {
    print('Creating menu: ${menu.toJson()}'); // Debug statement
    final response = await http.post(
      Uri.parse('$baseUrl/menus'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(menu.toJson()),
    );

    print(
        'Create menu response status code: ${response.statusCode}'); // Debug statement
    print('Create menu response body: ${response.body}'); // Debug statement

    if (response.statusCode == 200) {
      print('Menu created successfully'); // Debug statement
    } else {
      print('Failed to create menu ${response.statusCode}');
      print('Failed to create menu ${response.body}'); // Debug statement
      // throw Exception('Failed to create menu');
    }
  }

  Future<void> updateMenu(Menu menu, String token) async {
    print('Updating menu with ID: ${menu.menuID}'); // Debug statement
    final response = await http.put(
      Uri.parse('$baseUrl/menus/${menu.menuID}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(menu.toJson()),
    );

    print(
        'Update menu response status code: ${response.statusCode}'); // Debug statement
    print('Update menu response body: ${response.body}'); // Debug statement

    if (response.statusCode == 200) {
      print('Menu updated successfully'); // Debug statement
    } else {
      print('Failed to update menu'); // Debug statement
      throw Exception('Failed to update menu');
    }
  }

  Future<void> deleteMenu(int id, String token) async {
    print('Deleting menu with ID: $id'); // Debug statement
    final response = await http.delete(
      Uri.parse('$baseUrl/menus/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print(
        'Delete menu response status code: ${response.statusCode}'); // Debug statement
    print('Delete menu response body: ${response.body}'); // Debug statement

    if (response.statusCode == 200) {
      print('Menu deleted successfully'); // Debug statement
    } else {
      print('Failed to delete menu'); // Debug statement
      throw Exception('Failed to delete menu');
    }
  }
}
