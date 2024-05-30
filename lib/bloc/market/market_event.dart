part of 'market_bloc.dart';

abstract class MarketEvent {}

class MarketInitalEvent extends MarketEvent {}

class MarketUpdateEvent extends MarketEvent {
  String data;
  MarketUpdateEvent({
    required this.data,
  });
}
