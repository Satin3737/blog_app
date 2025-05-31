import 'package:blog_app/core/constants/messages.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/features/user/domain/entities/user.dart';
import 'package:blog_app/core/utils/connection_checker.dart';
import 'package:blog_app/features/auth/data/sources/auth_remote_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource authRemoteSource;
  final ConnectionChecker connectionChecker;

  const AuthRepositoryImpl({
    required this.authRemoteSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
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
  Future<Either<Failure, User>> signInWithEmailAndPassword({
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

  Future<Either<Failure, User>> _getUser(
    Future<User> Function() userRequest,
  ) async {
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
