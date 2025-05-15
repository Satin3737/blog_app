import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionChecker {
  final Connectivity connectivity = Connectivity();

  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
