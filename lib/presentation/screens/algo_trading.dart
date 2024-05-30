import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:stockgram/data/models/order.dart';
import 'package:stockgram/util/localstorage.dart';
import 'package:stockgram/util/service_locator.dart';

class AlgoTrading extends StatefulWidget {
  const AlgoTrading({super.key});

  @override
  State<AlgoTrading> createState() => _AlgoTradingState();
}

class _AlgoTradingState extends State<AlgoTrading> {
  List<Order> botorder = [];
  _fetchOrderHisotry() async {
    var t = await serviceLocator<BotDatabaseHelper>().queryAllRows();
    // List<Order> order = [];
    setState(() {
      for (var i in t) {
        botorder.add(Order.fromMap(i));
      }
    });
  }

  @override
  void initState() {
    _fetchOrderHisotry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bot Trading"),
      ),
      body: ListView.builder(
        itemCount: botorder.length,
        itemBuilder: (context, index) {
          Order order = botorder[index];
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
      ),
    );
  }
}
