import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:stockgram/util/localstorage.dart';
import 'package:stockgram/util/service_locator.dart';
part 'buy_sell_event.dart';
part 'buy_sell_state.dart';

class BuySellBloc extends Bloc<BuySellEvent, BuySellState> {
  BuySellBloc() : super(BuySellInitial()) {
    on<CreateOrder>(_createOrder);
  }

  FutureOr<void> _createOrder(
      CreateOrder event, Emitter<BuySellState> emit) async {
    log("Creating order..");
    serviceLocator<DatabaseHelper>().insert({
      "code": event.code,
      "ordertype": event.orderType,
      "qty": event.qty,
      "price": event.price,
      "total": event.total,
    });
    emit(
      OrderPlacedSuccessfully(
        orderType: event.orderType,
        price: event.price,
        qty: event.qty,
        total: event.total,
      ),
    );
  }
}
