import 'package:blog_app/core/router/routes.dart';
import 'package:blog_app/features/auth/ui/pages/signin_page.dart';
import 'package:blog_app/features/auth/ui/pages/signup_page.dart';
import 'package:blog_app/features/blog/ui/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/ui/pages/blog_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter router(bool isCurrentUser) => GoRouter(
    initialLocation: Routes.signIn,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.blog,
        builder: (BuildContext context, GoRouterState state) {
          return const BlogPage();
        },
        routes: [
          GoRoute(
            path: Routes.blogNew,
            builder: (BuildContext context, GoRouterState state) {
              return const AddNewBlogPage();
            },
          ),
        ],
      ),
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
    redirect: (BuildContext context, GoRouterState state) {
      final route = state.uri.path;
      final isAuthPages = route == Routes.signIn || route == Routes.signUp;

      if (isCurrentUser && isAuthPages) return Routes.blog;
      if (!isCurrentUser && !isAuthPages) return Routes.signIn;

      return null;
    },
  );
}
