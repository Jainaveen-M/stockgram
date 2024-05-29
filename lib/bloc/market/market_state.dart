part of 'market_bloc.dart';

@immutable
class MarketState {}

class MarketInitial extends MarketState {}

class MarketLoadingState extends MarketState {}

class MarketLoadedState extends MarketState {
  List<Stock> markets;
  MarketLoadedState({
    required this.markets,
  });
}
