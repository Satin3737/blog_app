import 'package:blog_app/core/constants/tables.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/features/user/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class UserRemoteSource {
  Future<void> signOutUser();

  Session? get currentSession;

  Future<UserModel?> getUserData();
}

class UserRemoteSourceImpl implements UserRemoteSource {
  final SupabaseClient supabaseClient;

  const UserRemoteSourceImpl(this.supabaseClient);

  @override
  Session? get currentSession => supabaseClient.auth.currentSession;

  @override
  Future<void> signOutUser() {
    return supabaseClient.auth.signOut();
  }

  @override
  Future<UserModel?> getUserData() async {
    try {
      final userData =
          await supabaseClient
              .from(Tables.users)
              .select()
              .eq('id', currentSession!.user.id)
              .single();

      return UserModel.fromJson(userData);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
