import 'package:equatable/equatable.dart';
import 'package:perkup_app/data/models/login/login_response_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final LoginResponse login;

  const AuthSuccess(this.login);

  @override
  List<Object> get props => [login];
}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}
