import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/bloc/algo_trading/alogtrading_bloc.dart';
import 'package:stockgram/data/models/order.dart';
import 'package:stockgram/util/toast.dart';

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
    alogtradingBloc.add(ListenSocketEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bot Trading"),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "This Bot is only configured for APPLE stock. Places buy orders when the price drops by 5% and sell orders when the price increases by 5%.",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: BlocConsumer<AlogtradingBloc, AlogtradingState>(
              bloc: alogtradingBloc,
              buildWhen: (previous, current) => current is! BotOrderCreate,
              listener: (context, state) {
                if (state is AlogtradingFailed) {
                  CustomToast.showErroMessage("Unable to fetch bot orders");
                }
                if (state is BotOrderCreate) {
                  CustomToast.showSuccessMessage(state.message);
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      order.code,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total : \$${double.parse(order.total).toStringAsFixed(2)}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
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
          ),
        ],
      ),
    );
  }
}
