part of 'market_bloc.dart';

class MarketState {}

class MarketInitial extends MarketState {}

class MarketLoadingState extends MarketState {}

class MarketLoadedState extends MarketState {
  List<Stock> markets;
  MarketLoadedState({
    required this.markets,
  });
}
