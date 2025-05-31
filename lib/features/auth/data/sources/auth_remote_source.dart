import 'package:blog_app/core/constants/messages.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/features/user/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteSource {
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final SupabaseClient supabaseClient;

  const AuthRemoteSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _fetchUser(
      () async => await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
      ),
    );
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _fetchUser(
      () async => await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      ),
    );
  }

  Future<UserModel> _fetchUser(
    Future<AuthResponse> Function() userRequest,
  ) async {
    try {
      final response = await userRequest();

      if (response.user == null) throw ServerException(Messages.noUserError);

      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
