import 'package:blog_app/core/common/cubits/user/app_user_cubit.dart';
import 'package:blog_app/core/router/app_router.dart';
import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/features/auth/ui/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/ui/bloc/blog_list/blog_list_bloc.dart';
import 'package:blog_app/features/blog/ui/bloc/blog_upload/blog_upload_bloc.dart';
import 'package:blog_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AppUserCubit>()),
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<BlogListBloc>()),
        BlocProvider(create: (_) => sl<BlogUploadBloc>()),
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
    context.read<AuthBloc>().add(AuthIsCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        return MaterialApp.router(
          routerConfig: AppRouter.router(state is AppUserLoggedIn),
          title: 'Blog App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
        );
      },
    );
  }
}
