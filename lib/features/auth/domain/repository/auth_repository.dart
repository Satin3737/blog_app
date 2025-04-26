import 'package:blog_app/features/auth/interfaces/interfaces.dart';

abstract interface class AuthRepository {
  AsyncUserResult signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  AsyncUserResult signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  AsyncUserResult getCurrentUserData();
}
