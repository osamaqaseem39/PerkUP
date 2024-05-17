import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_response_model.dart';
import 'api_constants.dart';

class ApiService {
  Future<LoginResponse> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

      print("${response.statusCode}");
      print("${jsonDecode(response.body)}");
    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
}
