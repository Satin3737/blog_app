import 'package:blog_app/core/utils/connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_connection_state.dart';

class AppConnectionCubit extends Cubit<AppConnectionState> {
  final ConnectionChecker connectionChecker;

  AppConnectionCubit(this.connectionChecker)
    : super(AppConnectionDisconnected()) {
    connectionChecker.addListener(_onConnectionChanged);
  }

  void _onConnectionChanged() {
    if (connectionChecker.isConnected) {
      emit(AppConnectionConnected());
    } else {
      emit(AppConnectionDisconnected());
    }
  }

  @override
  Future<void> close() {
    connectionChecker.removeListener(_onConnectionChanged);
    return super.close();
  }
}
