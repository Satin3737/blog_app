import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/features/user/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UserRepository {
  Future<Either<Failure, void>> signOutUser();

  Future<Either<Failure, User>> getUserData();
}
