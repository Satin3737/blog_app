import 'package:blog_app/core/common/cubits/user/app_user_cubit.dart';
import 'package:blog_app/core/features/user/domain/entities/user.dart';
import 'package:blog_app/core/features/user/domain/usecases/user_get_data.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/auth_signin_usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/auth_signup_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthSignUpUseCase _authSignUpUseCase;
  final AuthSignInUseCase _authSignInUseCase;
  final UserGetData _userGetData;
  final AppUserCubit _appUserCubit;

  AuthBloc({
    required AuthSignUpUseCase authSignUpUseCase,
    required AuthSignInUseCase authSignInUseCase,
    required UserGetData userGetData,
    required AppUserCubit appUserCubit,
  }) : _authSignUpUseCase = authSignUpUseCase,
       _authSignInUseCase = authSignInUseCase,
       _userGetData = userGetData,
       _appUserCubit = appUserCubit,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onSignUp);
    on<AuthSignIn>(_onSignIn);
    on<AuthIsCurrentUser>(_onIsCurrentUser);
  }

  void _onSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    final response = await _authSignUpUseCase(
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

  void _onSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    final response = await _authSignInUseCase(
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
