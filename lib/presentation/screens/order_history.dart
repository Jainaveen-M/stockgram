import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/bloc/order_history/order_history_bloc.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  OrderHistoryBloc orderHistoryBloc = OrderHistoryBloc();
  @override
  void initState() {
    orderHistoryBloc.add(FetchOrderHistory());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
        bloc: orderHistoryBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is OrderHistoryLoaded) {
            return ListView.builder(
                itemCount: state.orderHistory.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.orderHistory[index].code,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                state.orderHistory[index].orderType,
                                style: TextStyle(
                                  color: state.orderHistory[index].orderType ==
                                          "Buy"
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Qty: ${state.orderHistory[index].qty}',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Price: \$${state.orderHistory[index].price}',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Total: \$${state.orderHistory[index].total}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        });
  }
}
