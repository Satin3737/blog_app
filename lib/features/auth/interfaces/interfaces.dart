import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

typedef AsyncUserResult = Future<Either<Failure, User>>;
