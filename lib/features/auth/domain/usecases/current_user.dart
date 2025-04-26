import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/interfaces/interfaces.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final AuthRepository authRepository;

  const CurrentUser(this.authRepository);

  @override
  AsyncUserResult call(NoParams params) async {
    return await authRepository.getCurrentUserData();
  }
}
