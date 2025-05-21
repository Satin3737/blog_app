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

  sl
    ..registerLazySingleton<SupabaseClient>(() => supabase.client)
    ..registerLazySingleton<Box>(() => Hive.box(name: Tables.blogs));
}

void _initCore() {
  sl
    ..registerLazySingleton<ConnectionChecker>(() => ConnectionChecker())
    ..registerLazySingleton<AppUserCubit>(() => AppUserCubit());
}

void _initAuth() {
  sl
    // repository
    ..registerLazySingleton<AuthRemoteSource>(() => AuthRemoteSourceImpl(sl()))
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(authRemoteSource: sl(), connectionChecker: sl()),
    )
    // usecases
    ..registerLazySingleton<UserSignUp>(() => UserSignUp(sl()))
    ..registerLazySingleton<UserSignIn>(() => UserSignIn(sl()))
    ..registerLazySingleton<CurrentUser>(() => CurrentUser(sl()))
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
    ..registerLazySingleton<BlogsFetch>(() => BlogsFetch(sl()))
    ..registerLazySingleton<BlogCreate>(() => BlogCreate(sl()))
    ..registerLazySingleton<BlogEdit>(() => BlogEdit(sl()))
    ..registerLazySingleton<BlogDelete>(() => BlogDelete(sl()))
    ..registerLazySingleton<BlogGetImage>(() => BlogGetImage(sl()))
    // bloc
    ..registerLazySingleton<BlogBloc>(
      () => BlogBloc(
        blogsFetch: sl(),
        blogCreate: sl(),
        blogEdit: sl(),
        blogDelete: sl(),
        blogGetImage: sl(),
      ),
    );
}
