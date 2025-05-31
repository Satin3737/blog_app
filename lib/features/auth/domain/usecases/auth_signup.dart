import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/features/user/domain/entities/user.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthSignUp implements UseCase<User, AuthSignUpParams> {
  final AuthRepository authRepository;

  const AuthSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(AuthSignUpParams params) async {
    return await authRepository.signUpWithEmailAndPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class AuthSignUpParams {
  final String name;
  final String email;
  final String password;

  const AuthSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
