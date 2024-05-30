import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:stockgram/data/models/order.dart';
import 'package:stockgram/data/models/holding.dart';
import 'package:stockgram/util/local_storage_service.dart';
import 'package:stockgram/util/service_locator.dart';

class PortFolio extends StatefulWidget {
  const PortFolio({super.key});

  @override
  State<PortFolio> createState() => _PortFolioState();
}

class _PortFolioState extends State<PortFolio> {
  getMessages() async {
    List<Order> portfolio = [];
    var t = await serviceLocator<TradeOrderDB>().queryAllRows();
    for (var i in t) {
      portfolio.add(Order.fromMap(i));
    }
    aggregateOrders(portfolio);
    log(t.toString());
  }

  final List<Holdings> overallPortFolio = [];
  double totalInvested = 0;
  List<Holdings> aggregateOrders(List<Order> orders) {
    final Map<String, Map<String, dynamic>> portfolio = {};

    for (var order in orders) {
      if (portfolio.containsKey(order.code)) {
        if (order.orderType == "Buy") {
          portfolio[order.code]!['qty'] =
              (double.parse(portfolio[order.code]!['qty']) +
                      double.parse(order.qty))
                  .toString();
          portfolio[order.code]!['total'] =
              (double.parse(portfolio[order.code]!['total']) +
                      double.parse(order.total))
                  .toString();
        } else {
          portfolio[order.code]!['qty'] =
              (double.parse(portfolio[order.code]!['qty']) -
                      double.parse(order.qty))
                  .toString();
          portfolio[order.code]!['total'] =
              (double.parse(portfolio[order.code]!['total']) -
                      double.parse(order.total))
                  .toString();
        }
      } else {
        portfolio[order.code] = {
          'qty': order.qty,
          'code': order.code,
          'total': order.total,
        };
      }
    }

    for (String i in portfolio.keys) {
      log(i);
      setState(() {
        Holdings h = Holdings.fromMap(portfolio[i]!);
        totalInvested += double.parse(h.total);
        overallPortFolio.add(h);
      });
    }

    return overallPortFolio;
  }

  @override
  void initState() {
    getMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                "Total Invested",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                "\$${totalInvested.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: overallPortFolio.length,
            itemBuilder: (context, index) {
              Holdings holding = overallPortFolio[index];
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
                              holding.code,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Qty : ${holding.qty}",
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
                              "Total : \$${holding.total}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
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
        )
      ],
    );
  }
}
