import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'alogtrading_event.dart';
part 'alogtrading_state.dart';

class AlogtradingBloc extends Bloc<AlogtradingEvent, AlogtradingState> {
  AlogtradingBloc() : super(AlogtradingInitial()) {
    on<AlogtradingEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
