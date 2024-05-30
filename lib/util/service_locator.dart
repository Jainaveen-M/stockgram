import 'package:get_it/get_it.dart';
import 'package:stockgram/util/localstorage.dart';

final serviceLocator = GetIt.instance;

void initServiceLocator() {
  serviceLocator.registerSingleton<DatabaseHelper>(DatabaseHelper());
  serviceLocator.registerSingleton<BotDatabaseHelper>(BotDatabaseHelper());
}
