import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/data/models/order_book.dart';
part 'orderbook_event.dart';
part 'orderbook_state.dart';

class OrderbookBloc extends Bloc<OrderbookEvent, OrderbookState> {
  OrderbookBloc() : super(OrderbookInitial()) {
    on<RedfreshOrderBookData>(_refereshOrderBookData);
  } 

  FutureOr<void> _refereshOrderBookData(
      RedfreshOrderBookData event, Emitter<OrderbookState> emit) {
    List<OrderBookRecord> buy = [];
    List<OrderBookRecord> sell = [];
    var data = jsonDecode(event.data);
    for (var i in data['buy']) {
      buy.add(OrderBookRecord.fromMap(i));
    }
    for (var i in data['sell']) {
      sell.add(OrderBookRecord.fromMap(i));
    }
    emit(OrderbookLoaded(buyOrderBookData: buy, sellOrderBookData: sell));
  }
}
