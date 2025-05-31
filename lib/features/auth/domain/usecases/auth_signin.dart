import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/features/user/domain/entities/user.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthSignIn implements UseCase<User, AuthSignInParams> {
  final AuthRepository authRepository;

  const AuthSignIn(this.authRepository);

  @override
  Future<Either<Failure, User>> call(AuthSignInParams params) async {
    return await authRepository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class AuthSignInParams {
  final String email;
  final String password;

  const AuthSignInParams({required this.email, required this.password});
}
