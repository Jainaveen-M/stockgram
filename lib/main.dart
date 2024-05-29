import 'package:flutter/material.dart';
import 'package:stockgram/presentation/screens/home.dart';
import 'package:stockgram/util/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initServiceLocator();
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
      home: const Home(),
    );
  }
}
