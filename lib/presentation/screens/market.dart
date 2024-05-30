import 'package:flutter/material.dart';
import 'package:stockgram/bloc/market/market_bloc.dart';
import 'package:stockgram/data/models/stock.dart';
import 'package:stockgram/presentation/screens/buy_sell_popup.dart';
import 'package:stockgram/util/socket.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Market extends StatefulWidget {
  const Market({super.key});

  @override
  State<Market> createState() => _MarketState();
}

class _MarketState extends State<Market> {
  late WebSocketClient _client;
  List<Stock> stock = [];
  MarketBloc marketBloc = MarketBloc();
  @override
  void initState() {
    super.initState();
    marketBloc.add(MarketInitalEvent());
    _client = WebSocketClient('ws://localhost:8080');
    _client.stream.listen((message) {
      marketBloc.add(MarketUpdateEvent(data: message));
    });
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MarketBloc, MarketState>(
      bloc: marketBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is MarketLoadedState) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.markets.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(25.0),
                                  topRight: Radius.circular(25.0),
                                ),
                              ),
                              child: BuySellPopup(
                                code: state.markets[index].code,
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            maxRadius: 30,
                            backgroundColor: Colors.transparent,
                            child: Image.network(state.markets[index].img),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(state.markets[index].name),
                              Text(
                                state.markets[index].code,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            "\$${state.markets[index].price}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
