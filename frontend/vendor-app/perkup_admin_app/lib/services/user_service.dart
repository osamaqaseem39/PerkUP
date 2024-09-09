import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perkup_admin_app/models/user/user.dart';

class UserService {
  static const String baseUrl = 'https://192.168.10.18:7295/api';

  Future<List<User>> fetchUsers(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> fetchUserById(int id, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> createUser(User user, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      // 201 is the standard response code for successful creation
      throw Exception('Failed to create user');
    }
  }

  Future<void> updateUser(User user, String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/${user.userID}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int id, String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      // 204 is the standard response code for successful deletion
      throw Exception('Failed to delete user');
    }
  }
}
