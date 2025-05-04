import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/utils/connection_checker.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:blog_app/features/auth/data/sources/auth_remote_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/interfaces/interfaces.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

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
      if (!await connectionChecker.isConnected) {
        final session = authRemoteSource.currentSession;
        if (session == null) return Left(Failure('No internet connection'));
        final user = session.user;
        return Right(UserModel(id: user.id, email: user.email ?? '', name: ''));
      }

      final user = await authRemoteSource.getCurrentUserData();
      if (user == null) return Left(Failure('No user found'));
      return Right(user);
    } on supabase.AuthException catch (e) {
      return Left(Failure(e.message));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  AsyncUserResult _getUser(Future<User> Function() userRequest) async {
    try {
      if (!await connectionChecker.isConnected) {
        return Left(Failure('No internet connection'));
      }

      return Right(await userRequest());
    } on supabase.AuthException catch (e) {
      return Left(Failure(e.message));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
