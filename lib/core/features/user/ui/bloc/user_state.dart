part of 'user_cubit.dart';

@immutable
sealed class UserState {
  const UserState();
}

final class UserInitial extends UserState {}

final class UserLoggedIn extends UserState {
  final User user;

  const UserLoggedIn(this.user);
}
