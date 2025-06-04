import 'package:blog_app/core/features/user/ui/bloc/user_cubit.dart';
import 'package:blog_app/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: BlocListener<UserCubit, UserState>(
              listener: (context, state) async {
                await Future.delayed(const Duration(seconds: 1));
                if (!context.mounted) return;
                if (state is UserSuccess) context.go(Routes.blog);
                if (state is UserFailure) context.go(Routes.signIn);
              },
              child: const FlutterLogo(size: 128),
            ),
          ),
        ),
      ),
    );
  }
}
