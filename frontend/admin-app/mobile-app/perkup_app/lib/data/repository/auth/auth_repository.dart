import 'package:perkup_app/data/models/login/login_response_model.dart';
import 'package:perkup_app/util/shared_pref.dart';

import '../../network/api_service.dart';
class AuthRepository {
  final ApiService apiService;

  AuthRepository({required this.apiService});

  Future<LoginResponse> login(String username, String password) async {
    final login = await apiService.login(username, password);
    await SharedPrefs.setToken(login.token); // Assuming passwordHash is the token
    return login;
  }
}
