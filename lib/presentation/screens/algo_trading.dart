import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/bloc/algo_trading/alogtrading_bloc.dart';
import 'package:stockgram/data/models/order.dart';
import 'package:stockgram/util/localstorage.dart';
import 'package:stockgram/util/service_locator.dart';

class AlgoTrading extends StatefulWidget {
  const AlgoTrading({super.key});

  @override
  State<AlgoTrading> createState() => _AlgoTradingState();
}

class _AlgoTradingState extends State<AlgoTrading> {
  AlogtradingBloc alogtradingBloc = AlogtradingBloc();
  @override
  void initState() {
    alogtradingBloc.add(FetchBotTrades());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bot Trading"),
      ),
      body: BlocConsumer<AlogtradingBloc, AlogtradingState>(
        bloc: alogtradingBloc,
        listener: (context, state) {
          if (state is AlogtradingFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Unable to fetch bot orders",
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AlogtradingLoaded) {
            return ListView.builder(
              itemCount: state.botOrderHistory.length,
              itemBuilder: (context, index) {
                Order order = state.botOrderHistory[index];
                return Card(
                  elevation: 1.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.code,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Qty : ${order.qty}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total : \$${order.total}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                order.orderType,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: order.orderType == "Buy"
                                        ? Colors.green
                                        : Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
