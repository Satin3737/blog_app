import 'package:blog_app/core/common/cubits/user/app_user_cubit.dart';
import 'package:blog_app/core/features/user/domain/entities/user.dart';
import 'package:blog_app/core/features/user/domain/usecases/user_get_data.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/auth_signin.dart';
import 'package:blog_app/features/auth/domain/usecases/auth_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthSignUp _authSignUp;
  final AuthSignIn _authSignIn;
  final UserGetData _userGetData;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required AuthSignUp authSignUp,
    required AuthSignIn authSignIn,
    required UserGetData userGetData,
    required AppUserCubit appUserCubit,
  }) : _authSignUp = authSignUp,
       _authSignIn = authSignIn,
       _userGetData = userGetData,
       _appUserCubit = appUserCubit,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUpEvent>(_onSignUp);
    on<AuthSignInEvent>(_onSignIn);
    on<AuthIsCurrentUser>(_onIsCurrentUser);
  }

  void _onSignUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    final response = await _authSignUp(
      AuthSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onSignIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    final response = await _authSignIn(
      AuthSignInParams(email: event.email, password: event.password),
    );

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _onIsCurrentUser(
    AuthIsCurrentUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthCurrentUserLoading());

    final response = await _userGetData(NoParams());

    response.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }
}
