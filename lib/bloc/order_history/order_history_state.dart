part of 'order_history_bloc.dart';

class OrderHistoryState {}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  List<Order> orderHistory;
  OrderHistoryLoaded({
    required this.orderHistory,
  });
}

class OrderHistoryFailed extends OrderHistoryState {}
