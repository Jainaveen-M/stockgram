import 'package:get_it/get_it.dart';
import 'package:stockgram/util/local_storage_service.dart';

final serviceLocator = GetIt.instance;

void initServiceLocator() {
  serviceLocator.registerSingleton<TradeOrderDB>(TradeOrderDB());
  serviceLocator.registerSingleton<BotOrderDB>(BotOrderDB());
}
