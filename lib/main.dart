import 'package:blog_app/core/constants/messages.dart';
import 'package:blog_app/core/cubits/connection/app_connection_cubit.dart';
import 'package:blog_app/core/features/user/ui/bloc/user_cubit.dart';
import 'package:blog_app/core/router/app_router.dart';
import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/core/utils/snackbar_service.dart';
import 'package:blog_app/dependencies/dependencies.dart';
import 'package:blog_app/features/auth/ui/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/ui/bloc/blog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AppConnectionCubit>()),
        BlocProvider(create: (_) => sl<UserCubit>()),
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<BlogBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppConnectionCubit, AppConnectionState>(
      listener: (BuildContext context, state) {
        if (state is AppConnectionDisconnected) {
          SnackBarService.showRootSnackBar(Messages.noConnectionError);
        }
      },
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'Blog App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        scaffoldMessengerKey: SnackBarService.rootMessengerKey,
      ),
    );
  }
}
