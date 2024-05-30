import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/bloc/auth/auth_bloc.dart';
import 'package:stockgram/presentation/widgets/bottombar.dart';
import 'package:stockgram/presentation/widgets/login.dart';
import 'package:stockgram/presentation/widgets/signup.dart';
import 'package:stockgram/util/toast.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthBloc authBloc = AuthBloc();
  @override
  void initState() {
    authBloc.add(ShowLoginWidgetEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100.0, left: 30, right: 30),
              child: Center(
                child: Image.asset(
                  "assets/logo.png",
                  width: MediaQuery.of(context).size.width * 0.55,
                ),
              ),
            ),
            BlocConsumer<AuthBloc, AuthState>(
              bloc: authBloc,
              buildWhen: (previous, current) => current is! AuthLoginFailed,
              listenWhen: (previous, current) =>
                  current is AuthLoginFailed || current is AuthLoginFailed,
              listener: (context, state) {
                if (state is AuthLoginSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BottomBar(),
                    ),
                  );
                }
                if (state is AuthLoginFailed) {
                  CustomToast.showErroMessage(state.message);
                }
              },
              builder: (context, state) {
                if (state is ShowSignupScreen) {
                  return SignupWidget(
                    authBloc: authBloc,
                  );
                }
                return LoginWidget(
                  authBloc: authBloc,
                );
              },
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
