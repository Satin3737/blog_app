import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/features/user/domain/entities/user.dart';
import 'package:blog_app/core/features/user/domain/repository/user_repository.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

class UserGetDataUseCase implements UseCase<User, NoParams> {
  final UserRepository userRepository;

  const UserGetDataUseCase(this.userRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await userRepository.getUserData();
  }
}
