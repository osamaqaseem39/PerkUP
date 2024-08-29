import 'package:shared_preferences/shared_preferences.dart';

class LoginResponse {
  LoginResponse({
    required this.userId,
    required this.bearerToken,
    required this.token,
  });

  final int userId;
  final String bearerToken;
  final String token;

  LoginResponse.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        bearerToken = json['bearerToken'],
        token = json['token'];

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'bearerToken': bearerToken,
      'token': token,
    };
  }

  static Future<void> saveToPreferences(LoginResponse loginResponse) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', loginResponse.userId);
      await prefs.setString('bearerToken', loginResponse.bearerToken);
      await prefs.setString('token', loginResponse.token);
    } catch (e) {
      rethrow;
    }
  }

  static Future<LoginResponse?> loadFromPreferences() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('userId') ||
          !prefs.containsKey('bearerToken') ||
          !prefs.containsKey('token')) {
        return null;
      }

      final int userId = prefs.getInt('userId')!;
      final String bearerToken = prefs.getString('bearerToken')!;
      final String token = prefs.getString('token')!;

      return LoginResponse(
        userId: userId,
        bearerToken: bearerToken,
        token: token,
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error loading from preferences: $e');
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  static Future<void> clearPreferences() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      await prefs.remove('bearerToken');
      await prefs.remove('token');
    } catch (e) {
      // ignore: avoid_print
      print('Error clearing preferences: $e');
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }
}
