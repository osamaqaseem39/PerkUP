// lib/presentation/bloc/login/login_bloc.dart

import 'package:bloc/bloc.dart';
import 'package:perkup_admin_app/domain/usecases/login_usecase.dart';
import 'package:perkup_admin_app/presentation/bloc/login/login_event.dart';
import 'package:perkup_admin_app/presentation/bloc/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUsecase loginUsecase;

  LoginBloc({required this.loginUsecase}) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();
      try {
        final user = await loginUsecase(event.username, event.password);
        yield LoginSuccess(user: user);
      } catch (error) {
        yield LoginFailure(error: error.toString());
      }
    }
  }
}
