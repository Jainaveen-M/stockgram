import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>(_firebaseLogin);
  }

  FutureOr<void> _firebaseLogin(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      if (event.email.isEmpty) {
        emit(AuthLoginFailed(message: "Please enter you email"));
      } else if (event.password.isEmpty) {
        emit(AuthLoginFailed(message: "Please enter you password"));
      } else {
        emit(AuthLoading());
        final UserCredential result =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        String? email = result.user!.email;
        if (email != null) {
          emit(
            AuthLoginSuccess(email: email),
          );
        } else {
          emit(
            AuthLoginFailed(message: "Something went wrong. Please try again."),
          );
        }
      }
    } catch (e) {
      emit(
        AuthLoginFailed(message: "Something went wrong. Please try again."),
      );
    }
  }
}
