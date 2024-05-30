import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stockgram/bloc/buy_sell/buy_sell_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/bloc/orderbook/orderbook_bloc.dart';
import 'package:stockgram/presentation/widgets/orderbook.dart';
import 'package:stockgram/socket/socket.dart';
import 'package:stockgram/util/toast.dart';

class BuySellPopup extends StatefulWidget {
  final String code;
  const BuySellPopup({
    super.key,
    required this.code,
  });

  @override
  State<BuySellPopup> createState() => _BuySellPopupState();
}

class _BuySellPopupState extends State<BuySellPopup>
    with SingleTickerProviderStateMixin {
  int currentTab = 0;
  late TabController tabController;
  Color unselectedColor = Colors.grey;
  BuySellBloc buySellBloc = BuySellBloc();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderbookBloc>(
      create: (context) => OrderbookBloc(),
      child: BlocConsumer<BuySellBloc, BuySellState>(
        bloc: buySellBloc,
        listener: (context, state) {
          if (state is OrderPlacedSuccessfully) {
            Navigator.pop(context);
            CustomToast.showSuccessMessage(
                "${state.orderType} of ${state.qty} has been placed successfully.");
          }
          if (state is ErrorValidatingInput) {}
        },
        builder: (context, state) {
          return DefaultTabController(
            length: 3,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.code,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: OrderBook(
                      code: widget.code,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: TabBar(
                      controller: tabController,
                      indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(
                        color: Colors.orange,
                        width: 3,
                      )),
                      indicatorPadding:
                          const EdgeInsets.fromLTRB(6.0, 0.0, 6.0, 0.0),
                      tabs: [
                        Text(
                          'Buy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: currentTab == 0
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16.0,
                            color: currentTab == 0
                                ? Colors.black
                                : unselectedColor,
                          ),
                        ),
                        Text(
                          'Sell',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: currentTab == 1
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16.0,
                            color: currentTab == 1
                                ? Colors.black
                                : unselectedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        BuySellWidget(
                          orderType: "Buy",
                          bloc: buySellBloc,
                          code: widget.code,
                        ),
                        BuySellWidget(
                          orderType: "Sell",
                          bloc: buySellBloc,
                          code: widget.code,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BuySellWidget extends StatefulWidget {
  final String orderType;
  final String code;
  final BuySellBloc bloc;
  const BuySellWidget({
    super.key,
    required this.orderType,
    required this.code,
    required this.bloc,
  });

  @override
  State<BuySellWidget> createState() => _BuySellWidgetState();
}

class _BuySellWidgetState extends State<BuySellWidget> {
  double total = 0;
  TextEditingController qtyController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,5}')),
              ],
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: false,
              ),
              decoration: InputDecoration(
                hintText: 'Enter Quantity',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 4),
                  borderRadius: BorderRadius.circular(12),
                ),
                label: const Text('Enter Quantity'),
              ),
              controller: qtyController,
              onChanged: (value) {
                if (qtyController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  setState(() {
                    total = double.parse(qtyController.text) *
                        double.parse(priceController.text);
                  });
                }

                if (qtyController.text.isEmpty ||
                    priceController.text.isEmpty) {
                  setState(() {
                    total = 0;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,5}')),
              ],
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: false,
              ),
              decoration: InputDecoration(
                hintText: 'Enter price',
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 4),
                  borderRadius: BorderRadius.circular(12),
                ),
                label: const Text('Enter price'),
              ),
              controller: priceController,
              onChanged: (value) {
                if (qtyController.text.isNotEmpty &&
                    priceController.text.isNotEmpty) {
                  setState(() {
                    total = double.parse(qtyController.text) *
                        double.parse(priceController.text);
                  });
                }
                if (qtyController.text.isEmpty ||
                    priceController.text.isEmpty) {
                  setState(() {
                    total = 0;
                  });
                }
              },
            ),
          ),
          Center(
            child: Text("Total Amount : $total"),
          ),
          ElevatedButton(
            onPressed: () {
              widget.bloc.add(
                CreateOrder(
                  code: widget.code,
                  qty: qtyController.text,
                  price: priceController.text,
                  orderType: widget.orderType,
                  total: total.toString(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(MediaQuery.of(context).size.width * 0.3, 40),
              backgroundColor:
                  widget.orderType == "Buy" ? Colors.green : Colors.red,
            ),
            child: Text(widget.orderType),
          )
        ],
      ),
    );
  }
}
