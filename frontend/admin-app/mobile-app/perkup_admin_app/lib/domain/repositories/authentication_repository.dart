// lib/domain/repositories/authentication_repository.dart

import 'package:perkup_admin_app/domain/entities/user.dart';

abstract class AuthenticationRepository {
  Future<User> login(String username, String password);
  // Add other authentication-related methods here
}
