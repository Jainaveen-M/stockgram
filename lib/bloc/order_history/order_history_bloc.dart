import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/data/models/order.dart';
import 'package:stockgram/util/local_storage_service.dart';
import 'package:stockgram/util/service_locator.dart';
part 'order_history_event.dart';
part 'order_history_state.dart';

class OrderHistoryBloc extends Bloc<OrderHistoryEvent, OrderHistoryState> {
  OrderHistoryBloc() : super(OrderHistoryInitial()) {
    on<FetchOrderHistory>(_fetchOrderHisotry);
  }

  FutureOr<void> _fetchOrderHisotry(
      FetchOrderHistory event, Emitter<OrderHistoryState> emit) async {
    var t = await serviceLocator<TradeOrderDB>().queryAllRows();
    List<Order> order = [];
    for (var i in t) {
      order.add(Order.fromMap(i));
    }
    emit(OrderHistoryLoaded(orderHistory: order));
  }
}
