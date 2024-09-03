import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:perkup_user_app/models/login/login_response.dart';

class ApiService {
  static const String baseUrl = 'https://192.168.10.18:7295/api';

  Future<LoginResponse?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      return null;
    }
  }
}
