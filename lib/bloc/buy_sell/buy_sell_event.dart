part of 'buy_sell_bloc.dart';

@immutable
class BuySellEvent {}

class CreateOrder extends BuySellEvent {
  final String code;
  final String qty;
  final String price;
  final String orderType;
  final String total;
  CreateOrder({
    required this.code,
    required this.qty,
    required this.price,
    required this.orderType,
    required this.total,
  });
}
