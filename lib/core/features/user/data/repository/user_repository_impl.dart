import 'package:blog_app/core/constants/messages.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/features/user/data/models/user_model.dart';
import 'package:blog_app/core/features/user/data/sources/user_remote_source.dart';
import 'package:blog_app/core/features/user/domain/entities/user.dart';
import 'package:blog_app/core/features/user/domain/repository/user_repository.dart';
import 'package:blog_app/core/utils/connection_checker.dart';
import 'package:fpdart/fpdart.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteSource userRemoteSource;
  final ConnectionChecker connectionChecker;

  const UserRepositoryImpl({
    required this.userRemoteSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, void>> signOutUser() async {
    try {
      await userRemoteSource.signOutUser();
      return Right(null);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, User>> getUserData() async {
    try {
      if (!connectionChecker.isConnected) {
        final session = userRemoteSource.currentSession;
        if (session == null) return Left(Failure(Messages.noConnectionError));

        final rawUser = session.user;

        final user = UserModel(
          id: rawUser.id,
          email: rawUser.userMetadata?['email'] ?? '',
          name: rawUser.userMetadata?['name'] ?? '',
        );

        return Right(user);
      }

      final user = await userRemoteSource.getUserData();
      if (user == null) return Left(Failure(Messages.noUserError));
      return Right(user);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
