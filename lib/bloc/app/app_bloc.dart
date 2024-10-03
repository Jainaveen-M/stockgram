import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<AppLogoutEvent>(triggerLogout);
  }

  FutureOr<void> triggerLogout(AppLogoutEvent event, Emitter<AppState> emit) {
    log("logout called");
    emit(AppLogout());
  }
}
