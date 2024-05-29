part of 'orderbook_bloc.dart';

abstract class OrderbookEvent {}

class RedfreshOrderBookData extends OrderbookEvent {
  final dynamic data;
  RedfreshOrderBookData({
    required this.data,
  });
}
