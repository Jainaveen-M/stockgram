import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/bloc/app/app_bloc.dart';
import 'package:stockgram/bloc/auth/auth_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("E-Mail   "),
                BlocBuilder<AuthBloc, AuthState>(
                  bloc: BlocProvider.of<AuthBloc>(context),
                  builder: (context, state) {
                    if (state is AuthLoginSuccess) {
                      return Text(state.email);
                    }
                    return Text("");
                  },
                )
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AppBloc>().add(AppLogoutEvent());
            },
            child: Text("Change email"),
          ),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<AppBloc>(context).add(AppLogoutEvent());
            },
            child: Text("Logout"),
          )
        ],
      ),
    );
  }
}
