import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/core/session_storage_service.dart';
import 'package:stockgram/util/service_locator.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginEvent>(_firebaseLogin);
    on<AuthSignupEvent>(_firebaseSignup);
    on<ShowLoginWidgetEvent>(_showLoginWidget);
    on<ShowSignupWidgetEvent>(_showSignupWidget);
    on<CheckSession>(_checkSession);
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
          serviceLocator<SessionStorage>().writeString("session", email);
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

  FutureOr<void> _firebaseSignup(
      AuthSignupEvent event, Emitter<AuthState> emit) async {
    try {
      if (event.email.isEmpty) {
        emit(AuthLoginFailed(message: "Please enter you email"));
      } else if (event.password.isEmpty) {
        emit(AuthLoginFailed(message: "Please enter you password"));
      } else {
        emit(AuthLoading());
        final UserCredential result =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        String? email = result.user!.email;
        if (email != null) {
          serviceLocator<SessionStorage>().writeString("session", email);
          emit(
            AuthLoginSuccess(email: email),
          );
        } else {
          emit(
            AuthLoginFailed(message: "Something went wrong. Please try again."),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(
          AuthLoginFailed(message: 'The password provided is too weak.'),
        );
      } else if (e.code == 'email-already-in-use') {
        emit(
          AuthLoginFailed(
              message: 'The account already exists for that email.'),
        );
      }
    } catch (e) {
      emit(
        AuthLoginFailed(message: "Something went wrong. Please try again."),
      );
    }
  }

  FutureOr<void> _showSignupWidget(
      ShowSignupWidgetEvent event, Emitter<AuthState> emit) {
    emit(ShowSignupScreen());
  }

  FutureOr<void> _showLoginWidget(
      ShowLoginWidgetEvent event, Emitter<AuthState> emit) {
    emit(ShowLoginScreen());
  }

  FutureOr<void> _checkSession(
      CheckSession event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    String? t = await serviceLocator<SessionStorage>().readString("session");
    log("Email in session : ${t}");
    if (t != null && t.isNotEmpty) {
      emit(AuthLoginSuccess(email: t));
    } else {
      emit(ShowLoginScreen());
    }
  }
}
