import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stockgram/firebase_options.dart';
import 'package:stockgram/presentation/screens/algo_trading.dart';
import 'package:stockgram/presentation/screens/auth_screen.dart';
import 'package:stockgram/presentation/screens/home.dart';
import 'package:stockgram/util/bot_trading.dart';
import 'package:stockgram/util/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initServiceLocator();
  // BotTrading.initIosalte();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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

