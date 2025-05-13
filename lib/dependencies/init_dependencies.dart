part of 'dependencies.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  await _initBase();
  _initCore();
  _initAuth();
  _initBlog();
}

Future<void> _initBase() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  sl.registerLazySingleton(() => supabase.client);
  sl.registerLazySingleton(() => Hive.box(name: Tables.blogs));
}

void _initCore() {
  sl.registerFactory(() => InternetConnection());
  sl.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(sl()));
  sl.registerLazySingleton<AppUserCubit>(() => AppUserCubit());
}

void _initAuth() {
  sl
    // repository
    ..registerFactory<AuthRemoteSource>(() => AuthRemoteSourceImpl(sl()))
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteSource: sl(), connectionChecker: sl()),
    )
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
    ..registerFactory<BlogLocalSource>(() => BlogLocalSourceImpl(sl()))
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        blogRemoteSource: sl(),
        blogLocalSource: sl(),
        connectionChecker: sl(),
      ),
    )
    // usecases
    ..registerFactory<BlogCreate>(() => BlogCreate(sl()))
    ..registerFactory<BlogsFetch>(() => BlogsFetch(sl()))
    ..registerFactory<BlogDelete>(() => BlogDelete(sl()))
    // bloc
    ..registerLazySingleton<BlogBloc>(
      () => BlogBloc(blogsFetch: sl(), blogCreate: sl(), blogDelete: sl()),
    );
}
