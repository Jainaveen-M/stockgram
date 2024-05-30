import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stockgram/firebase_options.dart';
import 'package:stockgram/presentation/screens/auth_screen.dart';
import 'package:stockgram/util/bot_trading.dart';
import 'package:stockgram/util/local_storage_service.dart';
import 'package:stockgram/util/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initServiceLocator();
  BotTrading().initIsolate();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      home: const AuthScreen(),
    );
  }
}
