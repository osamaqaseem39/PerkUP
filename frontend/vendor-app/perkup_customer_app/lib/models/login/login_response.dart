import 'dart:convert'; // Import for JSON encoding/decoding
import 'package:shared_preferences/shared_preferences.dart';

class LoginResponse {
  LoginResponse({
    required this.userId,
    required this.bearerToken,
    required this.token,
    required this.displayName,
  });

  final int userId;
  final String bearerToken;
  final String token;
  final String displayName;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['userId'],
      bearerToken: json['bearerToken'],
      token: json['token'],
      displayName: json['displayName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bearerToken': bearerToken,
      'token': token,
      'displayName': displayName,
    };
  }

  static Future<void> saveToPreferences(LoginResponse loginResponse) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String jsonString = json.encode(loginResponse.toJson());
      await prefs.setString('loginResponse', jsonString);
    } catch (e) {
      rethrow;
    }
  }

  static Future<LoginResponse?> loadFromPreferences() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString('loginResponse');
      if (jsonString == null) {
        return null;
      }

      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return LoginResponse.fromJson(jsonMap);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> clearPreferences() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('loginResponse');
    } catch (e) {
      rethrow;
    }
  }
}
