part of 'buy_sell_bloc.dart';

abstract class BuySellState {}

//Action state
class OrderActionState extends BuySellState {}

class BuySellInitial extends BuySellState {}

class OrderPlacedSuccessfully extends BuySellState {
  String orderType;
  String qty;
  String price;
  String total;
  OrderPlacedSuccessfully({
    required this.orderType,
    required this.qty,
    required this.price,
    required this.total,
  });
}
