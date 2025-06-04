part of 'user_cubit.dart';

@immutable
sealed class UserState {
  const UserState();
}

final class UserInitial extends UserState {}

final class UserSuccess extends UserState {
  final User user;

  const UserSuccess(this.user);
}

final class UserFailure extends UserState {
  final String message;

  const UserFailure(this.message);
}
