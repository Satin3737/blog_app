part of 'app_connection_cubit.dart';

@immutable
sealed class AppConnectionState {
  const AppConnectionState();
}

final class AppConnectionConnected extends AppConnectionState {}

final class AppConnectionDisconnected extends AppConnectionState {}
