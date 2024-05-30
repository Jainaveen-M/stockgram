import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:stockgram/util/local_storage_service.dart';
import 'package:stockgram/util/service_locator.dart';
part 'buy_sell_event.dart';
part 'buy_sell_state.dart';

class BuySellBloc extends Bloc<BuySellEvent, BuySellState> {
  BuySellBloc() : super(BuySellInitial()) {
    on<CreateOrder>(_createOrder);
  }

  FutureOr<void> _createOrder(
      CreateOrder event, Emitter<BuySellState> emit) async {
    if (event.qty.isEmpty) {
      emit(ErrorValidatingInput(message: "Please enter a valid quantity"));
    } else if (event.price.isEmpty) {
      emit(ErrorValidatingInput(message: "Please enter a valid price"));
    } else {
      serviceLocator<TradeOrderDB>().insert({
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
}
