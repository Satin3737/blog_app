import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionCheckerImpl implements ConnectionChecker {
  final InternetConnection connection;

  const ConnectionCheckerImpl(this.connection);

  @override
  Future<bool> get isConnected async => await connection.hasInternetAccess;
}
