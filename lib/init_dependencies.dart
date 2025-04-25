import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_app/features/auth/data/sources/auth_remote_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signup.dart';
import 'package:blog_app/features/auth/ui/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initSupabase();
  _initAuth();
}

Future<void> _initSupabase() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  sl.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  sl.registerFactory<AuthRemoteSource>(() => AuthRemoteSourceImpl(sl()));
  sl.registerFactory<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerFactory<UserSignUp>(() => UserSignUp(sl()));
  sl.registerLazySingleton<AuthBloc>(() => AuthBloc(userSignUp: sl()));
}
