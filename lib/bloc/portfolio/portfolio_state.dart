part of 'portfolio_bloc.dart';

class PortfolioState {}

class PortfolioInitial extends PortfolioState {}

class PortfolioLoading extends PortfolioState {}

class PortfolioLoaded extends PortfolioState {
  final List<Holdings> overallPortFolio;
  final double totalInvested;

  PortfolioLoaded(
    this.overallPortFolio,
    this.totalInvested,
  );
}

class PortfolioFailed extends PortfolioState {}
