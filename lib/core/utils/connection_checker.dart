import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectionChecker extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  late final StreamSubscription<List<ConnectivityResult>> subscription;
  late ConnectivityResult _lastResult = ConnectivityResult.none;

  ConnectionChecker() {
    subscription = _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      _lastResult = result.isNotEmpty ? result.first : ConnectivityResult.none;
      notifyListeners();
    });
  }

  Future<void> initializeConnectivityStatus() async {
    final result = await _connectivity.checkConnectivity();
    _lastResult = result.isNotEmpty ? result.first : ConnectivityResult.none;
    notifyListeners();
  }

  bool get isConnected => _lastResult != ConnectivityResult.none;

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
