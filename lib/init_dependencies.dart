import 'package:blog_app/core/common/cubits/user/app_user_cubit.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_app/features/auth/data/sources/auth_remote_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signin.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signup.dart';
import 'package:blog_app/features/auth/ui/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/repository/blog_repository_impl.dart';
import 'package:blog_app/features/blog/data/sources/blog_remote_source.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecases/blog_upload.dart';
import 'package:blog_app/features/blog/domain/usecases/fetch_blog_list.dart';
import 'package:blog_app/features/blog/ui/bloc/blog_list/blog_list_bloc.dart';
import 'package:blog_app/features/blog/ui/bloc/blog_upload/blog_upload_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initSupabase();
  _initCore();
  _initAuth();
  _initBlog();
}

Future<void> _initSupabase() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  sl.registerLazySingleton(() => supabase.client);
}

void _initCore() {
  sl.registerLazySingleton<AppUserCubit>(() => AppUserCubit());
}

void _initAuth() {
  sl
    // repository
    ..registerFactory<AuthRemoteSource>(() => AuthRemoteSourceImpl(sl()))
    ..registerFactory<AuthRepository>(() => AuthRepositoryImpl(sl()))
    // usecases
    ..registerFactory<UserSignUp>(() => UserSignUp(sl()))
    ..registerFactory<UserSignIn>(() => UserSignIn(sl()))
    ..registerFactory<CurrentUser>(() => CurrentUser(sl()))
    // bloc
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        userSignUp: sl(),
        userSignIn: sl(),
        currentUser: sl(),
        appUserCubit: sl(),
      ),
    );
}

void _initBlog() {
  sl
    // repository
    ..registerFactory<BlogRemoteSource>(() => BlogRemoteSourceImpl(sl()))
    ..registerFactory<BlogRepository>(() => BlogRepositoryImpl(sl()))
    // usecases
    ..registerFactory<BlogUpload>(() => BlogUpload(sl()))
    ..registerFactory<FetchBlogList>(() => FetchBlogList(sl()))
    // bloc
    ..registerLazySingleton<BlogListBloc>(() => BlogListBloc(sl()))
    ..registerLazySingleton<BlogUploadBloc>(
      () => BlogUploadBloc(blogUpload: sl(), blogListBloc: sl()),
    );
}
