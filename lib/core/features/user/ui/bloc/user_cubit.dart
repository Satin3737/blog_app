import 'package:blog_app/core/features/user/domain/entities/user.dart';
import 'package:blog_app/core/features/user/domain/usecases/user_get_data_usecase.dart';
import 'package:blog_app/core/features/user/domain/usecases/user_signout_usecase.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserGetDataUseCase _userGetDataUseCase;
  final UserSignOutUseCase _userSignOutUseCase;

  UserCubit({
    required UserGetDataUseCase userGetDataUseCase,
    required UserSignOutUseCase userSignOutUseCase,
  }) : _userGetDataUseCase = userGetDataUseCase,
       _userSignOutUseCase = userSignOutUseCase,
       super(UserInitial());

  void getUser() async {
    final response = await _userGetDataUseCase(NoParams());

    response.fold(
      (failure) => emit(UserFailure(failure.message)),
      (user) => emit(UserSuccess(user)),
    );
  }

  void signOut() async {
    final response = await _userSignOutUseCase(NoParams());

    response.fold(
      (failure) => emit(UserFailure(failure.message)),
      (_) => emit(UserInitial()),
    );
  }
}
