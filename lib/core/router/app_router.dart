import 'package:blog_app/core/router/routes.dart';
import 'package:blog_app/features/auth/ui/pages/signin_page.dart';
import 'package:blog_app/features/auth/ui/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: Routes.signIn,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.signIn,
        builder: (BuildContext context, GoRouterState state) {
          return const SignInPage();
        },
      ),
      GoRoute(
        path: Routes.signUp,
        builder: (BuildContext context, GoRouterState state) {
          return const SignUpPage();
        },
      ),
    ],
  );
}
