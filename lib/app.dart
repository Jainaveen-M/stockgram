import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/bloc/app/app_bloc.dart';
import 'package:stockgram/presentation/screens/auth_screen.dart';

class AppStatus extends StatelessWidget {
  final Widget child;
  const AppStatus({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      bloc: BlocProvider.of<AppBloc>(context),
      listener: (context, state) {
        if (state is AppLogout) {
          log("came to logout listner");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()),
            (route) => false,
          );
          // navKey.currentState?.pushReplacement(
          //     MaterialPageRoute(builder: (context) => const AuthScreen()));
          // return AuthScreen();
          // AuthScreen.route();
        }
      },
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return child;
        },
      ),
    );
  }
}
