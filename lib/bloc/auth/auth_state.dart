part of 'auth_bloc.dart';

class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final String email;
  AuthLoginSuccess({
    required this.email,
  });
}

class AuthLoginFailed extends AuthState {
  final String message;
  AuthLoginFailed({
    required this.message,
  });
}
