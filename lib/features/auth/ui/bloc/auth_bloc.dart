import 'package:blog_app/core/features/user/domain/entities/user.dart';
import 'package:blog_app/core/features/user/domain/usecases/user_get_data_usecase.dart';
import 'package:blog_app/core/features/user/ui/bloc/user_cubit.dart';
import 'package:blog_app/features/auth/domain/usecases/auth_signin_usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/auth_signup_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthSignUpUseCase _authSignUpUseCase;
  final AuthSignInUseCase _authSignInUseCase;
  final UserCubit _userCubit;

  AuthBloc({
    required AuthSignUpUseCase authSignUpUseCase,
    required AuthSignInUseCase authSignInUseCase,
    required UserGetDataUseCase userGetDataUseCase,
    required UserCubit userCubit,
  }) : _authSignUpUseCase = authSignUpUseCase,
       _authSignInUseCase = authSignInUseCase,
       _userCubit = userCubit,
       super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onSignUp);
    on<AuthSignIn>(_onSignIn);
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

  void _emitAuthSuccess(User user, Emitter<AuthState> emit) {
    _userCubit.getUser();
    emit(AuthSuccess(user));
  }
}
