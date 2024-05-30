import 'dart:isolate';
import 'package:stockgram/core/local_storage_service.dart';
import 'package:stockgram/data/repositary/stock_data.dart';
import 'package:stockgram/util/service_locator.dart';

class BotTrading {
  static ReceivePort? _receivePort;
  ReceivePort get receivePort {
    if (_receivePort != null) return _receivePort!;
    _receivePort = ReceivePort();
    return _receivePort!;
  }

  static void processMarketData(SendPort sendPort) async {
    final marketData = previousData;
    final currentBestBuyPrice = double.parse(marketData["buy"]![0]["price"]!);
    final currentBestSellPrice = double.parse(marketData["sell"]![0]["price"]!);
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
    sendPort.send(sendData);
  }

  void initIsolate() async {
    await Isolate.spawn(
      processMarketData,
      receivePort.sendPort,
    ); // Initial price
    receivePort.listen((message) {
      final buySignal = message["buy"]["value"] as bool;
      final sellSignal = message["sell"]["value"] as bool;

      if (buySignal) {
        serviceLocator<BotOrderDB>().insert({
          "code": "AAPL",
          "ordertype": "Buy",
          "qty": message["buy"]["data"]['qty'],
          "price": message["buy"]["data"]['price'],
          "total": (double.parse(message["buy"]["data"]['qty']) *
                  double.parse(message["buy"]["data"]['price']))
              .toString(),
        });
      }

      if (sellSignal) {
        serviceLocator<BotOrderDB>().insert({
          "code": "AAPL",
          "ordertype": "Sell",
          "qty": message["buy"]["data"]['qty'],
          "price": message["buy"]["data"]['price'],
          "total": (double.parse(message["buy"]["data"]['qty']) *
                  double.parse(message["buy"]["data"]['price']))
              .toString(),
        });
      }
    });
  }
}
