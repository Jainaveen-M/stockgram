import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:isolate';

import 'package:stockgram/socket/socket.dart';
import 'package:stockgram/util/localstorage.dart';
import 'package:stockgram/util/service_locator.dart';

class BotTrading {
  // Function to simulate market data updates (replace with actual data source)
  static Map<String, dynamic> previousData = {
    "buy": [
      {"price": "43.48", "qty": "94"},
      {"price": "69.83", "qty": "13"},
      {"price": "70.41", "qty": "60"},
      {"price": "48.74", "qty": "26"},
      {"price": "2.12", "qty": "7"}
    ],
    "sell": [
      {"price": "92.91", "qty": "48"},
      {"price": "94.66", "qty": "20"},
      {"price": "26.49", "qty": "49"},
      {"price": "22.75", "qty": "83"},
      {"price": "89.77", "qty": "28"}
    ]
  };
  static Future<Map<String, List<Map<String, String>>>> getMarketData() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    return {
      "buy": [
        {"price": "43.48", "qty": "94"},
        {"price": "69.83", "qty": "13"},
        {"price": "70.41", "qty": "60"},
        {"price": "48.74", "qty": "26"},
        {"price": "2.12", "qty": "7"}
      ],
      "sell": [
        {"price": "92.91", "qty": "48"},
        {"price": "94.66", "qty": "20"},
        {"price": "26.49", "qty": "49"},
        {"price": "22.75", "qty": "83"},
        {"price": "89.77", "qty": "28"}
      ]
    };
  }

  static listSocket(SendPort sendPort) {
    WebSocketClient _orderbookClient = WebSocketClient('ws://localhost:8060');
    _orderbookClient.stream.listen((message) {
      var marketData = jsonDecode(message);

      final currentBestBuyPrice = double.parse(marketData["buy"]![0]["price"]!);
      final currentBestSellPrice =
          double.parse(marketData["sell"]![0]["price"]!);
      final previousBestBuyPrice =
          double.parse(previousData["buy"]![0]["price"]!);
      final previousBestSellPrice =
          double.parse(previousData["sell"]![0]["price"]!);
      final buySignal = previousBestBuyPrice * 0.05 > currentBestBuyPrice;
      final sellSignal = previousBestSellPrice * 0.05 < currentBestSellPrice;
      // log(previousBestBuyPrice.toString() +
      //     "    " +
      //     currentBestBuyPrice.toString());
      // log(previousBestSellPrice.toString() +
      //     "    " +
      //     currentBestSellPrice.toString());
      previousData = marketData;
      var sendData = {
        "buy": {"value": true, "data": marketData["buy"]![0]},
        "sell": {"value": true, "data": marketData["sell"]![0]}
      };
      sendPort.send(sendData);
    });
  }

// Isolate function to process market data and generate trading signals
  static void processMarketData(SendPort sendPort) async {
    final marketData = await getMarketData();
    final currentBestBuyPrice = double.parse(marketData["buy"]![0]["price"]!);
    final currentBestSellPrice = double.parse(marketData["sell"]![0]["price"]!);
    final previousBestBuyPrice =
        double.parse(previousData["buy"]![0]["price"]!);
    final previousBestSellPrice =
        double.parse(previousData["sell"]![0]["price"]!);
    final buySignal = previousBestBuyPrice > currentBestBuyPrice;
    final sellSignal = previousBestSellPrice < currentBestSellPrice;
    previousData = marketData;
    var sendData = {
      "buy": {"value": true, "data": marketData["buy"]![0]},
      "sell": {"value": true, "data": marketData["sell"]![0]}
    };
    sendPort.send(sendData);
  }

  static void initIosalte() async {
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(
      processMarketData,
      receivePort.sendPort,
    ); // Initial price
    listSocket(receivePort.sendPort);
    receivePort.listen((message) {
      log(message.toString());
      final buySignal = message["buy"]["value"] as bool;
      final sellSignal = message["sell"]["value"] as bool;

      if (buySignal) {
        log("Buy signal generated! (Price decreased by 5%)");
        serviceLocator<BotDatabaseHelper>().insert({
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
        log("Sell signal generated! (Price increased by 5%)");
        serviceLocator<BotDatabaseHelper>().insert({
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