import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/bloc/auth/auth_bloc.dart';
import 'package:stockgram/firebase_options.dart';
import 'package:stockgram/presentation/screens/auth_screen.dart';
import 'package:stockgram/core/bot_trading.dart';
import 'package:stockgram/util/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initServiceLocator();
  BotTrading().initIsolate();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stockgram',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: const TextTheme(),
      ),
      themeMode: ThemeMode.dark,
      home: BlocProvider(
        create: (context) => AuthBloc(),
        child: const AuthScreen(),
      ),
    );
  }
}
