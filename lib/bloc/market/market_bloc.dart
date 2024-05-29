import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stockgram/data/models/stock.dart';
import 'package:stockgram/data/repositary/stock_data.dart';

part 'market_event.dart';
part 'market_state.dart';

class MarketBloc extends Bloc<MarketEvent, MarketState> {
  MarketBloc() : super(MarketInitial()) {
    on<MarketInitalEvent>(_getInitialData);
    on<MarketUpdateEvent>(_updateMarketData);
  }

  FutureOr<void> _getInitialData(
      MarketInitalEvent event, Emitter<MarketState> emit) async {
    emit(MarketLoadingState());
    await Future.delayed(
      const Duration(milliseconds: 500),
    );
    List<Stock> stock = [];
    for (var i in stockList) {
      stock.add(Stock.fromMap(i));
    }
    emit(MarketLoadedState(markets: stock));
  }

  FutureOr<void> _updateMarketData(
      MarketUpdateEvent event, Emitter<MarketState> emit) {
    var data = jsonDecode(event.data);
    List<Stock> stock = [];
    for (var i in stockList) {
      stock.add(Stock.fromMap(i));
    }
    for (int j = 0; j < stock.length; j++) {
      stock[j].price = data[stock[j].code];
    }
    emit(MarketLoadedState(markets: stock));
  }
}
