import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stockgram/core/local_storage_service.dart';
import 'package:stockgram/data/models/holding.dart';
import 'package:stockgram/data/models/order.dart';
import 'package:stockgram/util/service_locator.dart';

part 'portfolio_event.dart';
part 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  PortfolioBloc() : super(PortfolioInitial()) {
    on<FetchPortFolio>(_fetchPortfolio);
  }

  FutureOr<void> _fetchPortfolio(
      FetchPortFolio event, Emitter<PortfolioState> emit) async {
    try {
      double totalInvested = 0;
      List<Holdings> overallPortFolio = [];
      List<Order> p = [];
      final Map<String, Map<String, dynamic>> portfolio = {};
      emit(PortfolioLoading());
      var t = await serviceLocator<TradeOrderDB>().queryAllRows();
      for (var i in t) {
        p.add(Order.fromMap(i));
      }
      for (var order in p) {
        if (portfolio.containsKey(order.code)) {
          if (order.orderType == "Buy") {
            portfolio[order.code]!['qty'] =
                (double.parse(portfolio[order.code]!['qty']) +
                        double.parse(order.qty))
                    .toString();
            portfolio[order.code]!['total'] =
                (double.parse(portfolio[order.code]!['total']) +
                        double.parse(order.total))
                    .toString();
          } else {
            portfolio[order.code]!['qty'] =
                (double.parse(portfolio[order.code]!['qty']) -
                        double.parse(order.qty))
                    .toString();
            portfolio[order.code]!['total'] =
                (double.parse(portfolio[order.code]!['total']) -
                        double.parse(order.total))
                    .toString();
          }
        } else {
          portfolio[order.code] = {
            'qty': order.qty,
            'code': order.code,
            'total': order.total,
          };
        }
      }

      for (String i in portfolio.keys) {
        Holdings h = Holdings.fromMap(portfolio[i]!);
        if (double.parse(h.qty) > 0) {
          overallPortFolio.add(h);
          totalInvested += double.parse(h.total);
        }
      }

      emit(PortfolioLoaded(overallPortFolio, totalInvested));
    } catch (e) {
      emit(PortfolioFailed());
    }
  }
}
