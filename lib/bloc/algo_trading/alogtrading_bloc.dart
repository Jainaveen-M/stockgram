import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/data/models/order.dart';
import 'package:stockgram/data/repositary/stock_data.dart';
import 'package:stockgram/socket/socket.dart';
import 'package:stockgram/util/bot_trading.dart';
import 'package:stockgram/util/localstorage.dart';
import 'package:stockgram/util/service_locator.dart';

part 'alogtrading_event.dart';
part 'alogtrading_state.dart';

class AlogtradingBloc extends Bloc<AlogtradingEvent, AlogtradingState> {
  AlogtradingBloc() : super(AlogtradingInitial()) {
    on<FetchBotTrades>(getBotTrades);
    on<ListenSocketEvent>(listenSocketEvent);
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

  FutureOr<void> listenSocketEvent(
      ListenSocketEvent event, Emitter<AlogtradingState> emit) async {
    WebSocketClient orderbookClient = WebSocketClient('ws://localhost:8060');
    await emit.forEach(
      orderbookClient.stream,
      onData: (message) {
        var marketData = jsonDecode(message);
        final currentBestBuyPrice =
            double.parse(marketData["buy"]![0]["price"]!);
        final currentBestSellPrice =
            double.parse(marketData["sell"]![0]["price"]!);
        final previousBestBuyPrice =
            double.parse(previousData["buy"]![0]["price"]!);
        final previousBestSellPrice =
            double.parse(previousData["sell"]![0]["price"]!);
        bool buySignal = previousBestBuyPrice * 0.05 > currentBestBuyPrice;
        bool sellSignal = previousBestSellPrice * 0.05 < currentBestSellPrice;
        previousData = marketData;
        var sendData = {
          "buy": {"value": buySignal, "data": marketData["buy"]![0]},
          "sell": {"value": sellSignal, "data": marketData["sell"]![0]}
        };

        SendPort sendPort = BotTrading().receivePort.sendPort;
        sendPort.send(sendData);
        if (buySignal) {
          return BotOrderCreate(
              message:
                  "Bot buy order created ${marketData['buy']![0].toString()}");
        } else if (sellSignal) {
          return BotOrderCreate(
              message:
                  "Bot sell order created ${marketData['sell']![0].toString()}");
        }
        return AlogtradingFailed();
      },
    );
  }
}
