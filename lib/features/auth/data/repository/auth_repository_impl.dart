import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/constants/messages.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/utils/connection_checker.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/data/sources/auth_remote_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/interfaces/interfaces.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource authRemoteSource;
  final ConnectionChecker connectionChecker;

  const AuthRepositoryImpl({
    required this.authRemoteSource,
    required this.connectionChecker,
  });

  @override
  AsyncUserResult signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemoteSource.signUpWithEmailAndPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  @override
  AsyncUserResult signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await authRemoteSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  AsyncUserResult getCurrentUserData() async {
    try {
      if (!connectionChecker.isConnected) {
        final session = authRemoteSource.currentSession;
        if (session == null) return Left(Failure(Messages.noConnectionError));
        final user = session.user;
        return Right(UserModel(id: user.id, email: user.email ?? '', name: ''));
      }

      final user = await authRemoteSource.getCurrentUserData();
      if (user == null) return Left(Failure(Messages.noUserError));
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  AsyncUserResult _getUser(Future<User> Function() userRequest) async {
    try {
      if (!connectionChecker.isConnected) {
        return Left(Failure(Messages.noConnectionError));
      }

      return Right(await userRequest());
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
