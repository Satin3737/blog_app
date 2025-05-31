part of 'dependencies.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initBase();
  _initCore();
  _initUser();
  _initAuth();
  _initBlog();
}

Future<void> _initBase() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  sl
    ..registerLazySingleton<SupabaseClient>(() => supabase.client)
    ..registerLazySingleton<Box>(() => Hive.box(name: Tables.blogs));
}

void _initCore() {
  sl
    ..registerLazySingleton<ConnectionChecker>(() => ConnectionChecker())
    ..registerLazySingleton<AppConnectionCubit>(() => AppConnectionCubit(sl()))
    ..registerLazySingleton<AppUserCubit>(() => AppUserCubit());
}

// core features

void _initUser() {
  sl
    // repository
    ..registerLazySingleton<UserRemoteSource>(() => UserRemoteSourceImpl(sl()))
    ..registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(userRemoteSource: sl(), connectionChecker: sl()),
    )
    // usecases
    ..registerLazySingleton<UserGetData>(() => UserGetData(sl()))
    ..registerLazySingleton<UserSignOut>(() => UserSignOut(sl()));
  // bloc
}

// features

void _initAuth() {
  sl
    // repository
    ..registerLazySingleton<AuthRemoteSource>(() => AuthRemoteSourceImpl(sl()))
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteSource: sl(), connectionChecker: sl()),
    )
    // usecases
    ..registerLazySingleton<AuthSignUpUseCase>(() => AuthSignUpUseCase(sl()))
    ..registerLazySingleton<AuthSignInUseCase>(() => AuthSignInUseCase(sl()))
    // bloc
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
        authSignUpUseCase: sl(),
        authSignInUseCase: sl(),
        userGetData: sl(),
        appUserCubit: sl(),
      ),
    );
}

void _initBlog() {
  sl
    // repository
    ..registerLazySingleton<BlogRemoteSource>(() => BlogRemoteSourceImpl(sl()))
    ..registerLazySingleton<BlogLocalSource>(() => BlogLocalSourceImpl(sl()))
    ..registerLazySingleton<BlogRepository>(
      () => BlogRepositoryImpl(
        blogRemoteSource: sl(),
        blogLocalSource: sl(),
        connectionChecker: sl(),
      ),
    )
    // usecases
    ..registerLazySingleton<BlogsFetchUseCase>(() => BlogsFetchUseCase(sl()))
    ..registerLazySingleton<BlogCreateUseCase>(() => BlogCreateUseCase(sl()))
    ..registerLazySingleton<BlogEditUseCase>(() => BlogEditUseCase(sl()))
    ..registerLazySingleton<BlogDeleteUseCase>(() => BlogDeleteUseCase(sl()))
    // bloc
    ..registerLazySingleton<BlogBloc>(
      () => BlogBloc(
        blogsFetchUseCase: sl(),
        blogCreateUseCase: sl(),
        blogEditUseCase: sl(),
        blogDeleteUseCase: sl(),
      ),
    );
}
