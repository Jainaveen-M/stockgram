import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/bloc/orderbook/orderbook_bloc.dart';
import 'package:stockgram/socket/socket.dart';

class OrderBook extends StatefulWidget {
  const OrderBook({super.key});

  @override
  State<OrderBook> createState() => _OrderBookState();
}

class _OrderBookState extends State<OrderBook> {
  OrderbookBloc orderbookBloc = OrderbookBloc();
  //websocket
  late WebSocketClient _orderbookClient;

  @override
  void initState() {
    _orderbookClient = WebSocketClient('ws://localhost:8060');
    _orderbookClient.stream.listen((message) {
      log(message);
      orderbookBloc.add(RedfreshOrderBookData(data: message));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderbookBloc, OrderbookState>(
      bloc: orderbookBloc,
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if (state is OrderbookLoaded) {
          return Row(
            children: [
              Expanded(
                child: Container(
                  height: 200,
                  color: Colors.green.shade100,
                  child: ListView.builder(
                    itemCount: state.buyOrderBookData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          color: Colors.green.shade200,
                          child: Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(state.buyOrderBookData[index].qty),
                                Text(state.buyOrderBookData[index].price),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 200,
                  color: Colors.red.shade100,
                  child: ListView.builder(
                    itemCount: state.sellOrderBookData.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          color: Colors.red.shade200,
                          child: Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(state.sellOrderBookData[index].qty),
                                Text(state.sellOrderBookData[index].price),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
