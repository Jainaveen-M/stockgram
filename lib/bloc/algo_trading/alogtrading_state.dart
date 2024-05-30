part of 'alogtrading_bloc.dart';

class AlogtradingState {}

class AlogtradingInitial extends AlogtradingState {}

class AlogtradingLoading extends AlogtradingState {}

class AlogtradingLoaded extends AlogtradingState {
  List<Order> botOrderHistory;
  AlogtradingLoaded({
    required this.botOrderHistory,
  });
}

class BotOrderCreate extends AlogtradingState {
  final String message;
  BotOrderCreate({
    required this.message,
  });
}

class AlogtradingFailed extends AlogtradingState {}
