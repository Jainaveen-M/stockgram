import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/app.dart';
import 'package:stockgram/bloc/app/app_bloc.dart';
import 'package:stockgram/bloc/auth/auth_bloc.dart';
import 'package:stockgram/firebase_options.dart';
import 'package:stockgram/core/bot_trading.dart';
import 'package:stockgram/presentation/screens/auth_screen.dart';
import 'package:stockgram/presentation/screens/profile.dart';
import 'package:stockgram/util/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initServiceLocator();
  BotTrading().initIsolate();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // runApp(BlocProvider(
  //   create: (context) => AppBloc(),
  //   child: const MyApp(),
  // ));
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Stockgram',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.green,
          textTheme: const TextTheme(),
        ),
        themeMode: ThemeMode.dark,
        home: AppStatus(
          child: ProfileScreen(),
        ),
      ),
    );
  }
}
