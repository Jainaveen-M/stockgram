part of 'orderbook_bloc.dart';

class OrderbookState {}

class OrderbookInitial extends OrderbookState {}

class OrderbookLoading extends OrderbookState {}

class OrderbookLoaded extends OrderbookState {
  final List<OrderBookRecord> buyOrderBookData;
  final List<OrderBookRecord> sellOrderBookData;
  OrderbookLoaded({
    required this.buyOrderBookData,
    required this.sellOrderBookData,
  });
}

class OrderbookFailed extends OrderbookState {}
