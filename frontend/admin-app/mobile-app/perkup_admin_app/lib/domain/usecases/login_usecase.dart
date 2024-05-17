// lib/domain/usecases/login_usecase.dart

import 'package:perkup_admin_app/domain/entities/user.dart';
import 'package:perkup_admin_app/domain/repositories/authentication_repository.dart';

class LoginUsecase {
  final AuthenticationRepository repository;

  LoginUsecase({required this.repository});

  Future<User> call(String username, String password) async {
    return await repository.login(username, password);
  }
}
