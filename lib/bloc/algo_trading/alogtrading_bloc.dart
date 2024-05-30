import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stockgram/data/models/order.dart';
import 'package:stockgram/util/localstorage.dart';
import 'package:stockgram/util/service_locator.dart';

part 'alogtrading_event.dart';
part 'alogtrading_state.dart';

class AlogtradingBloc extends Bloc<AlogtradingEvent, AlogtradingState> {
  AlogtradingBloc() : super(AlogtradingInitial()) {
    on<FetchBotTrades>(getBotTrades);
  }

  FutureOr<void> getBotTrades(
      FetchBotTrades event, Emitter<AlogtradingState> emit) async {
    emit(AlogtradingLoading());
    var t = await serviceLocator<BotDatabaseHelper>().queryAllRows();
    List<Order> order = [];
    for (var i in t) {
      order.add(Order.fromMap(i));
    }
    emit(AlogtradingLoaded(botOrderHistory: order));
  }
}
