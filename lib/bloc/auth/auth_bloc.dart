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
    final UserCredential result =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: "jaitest@gmail.com",
      password: "Jai@1234",
    );
    String? email = result.user!.email;
    if (email != null) {
      emit(AuthLoginSuccess(email: email));
    } else {}
  }
}
