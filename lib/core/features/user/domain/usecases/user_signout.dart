import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/features/user/domain/repository/user_repository.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

class UserSignOut implements UseCase<void, NoParams> {
  final UserRepository userRepository;

  const UserSignOut(this.userRepository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await userRepository.signOutUser();
  }
}
