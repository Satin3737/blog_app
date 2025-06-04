import 'package:blog_app/core/features/user/ui/bloc/user_cubit.dart';
import 'package:blog_app/core/router/routes.dart';
import 'package:blog_app/core/router/widgets/route_with_nested_navigation.dart';
import 'package:blog_app/core/utils/stream_to_listenable.dart';
import 'package:blog_app/dependencies/dependencies.dart';
import 'package:blog_app/features/auth/ui/pages/signin_page.dart';
import 'package:blog_app/features/auth/ui/pages/signup_page.dart';
import 'package:blog_app/features/auth/ui/pages/splash_page.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/ui/pages/blog_page.dart';
import 'package:blog_app/features/blog/ui/pages/manage_blog_page.dart';
import 'package:blog_app/features/blog/ui/pages/single_blog_page.dart';
import 'package:blog_app/features/profile/ui/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorBlogKey = GlobalKey<NavigatorState>();
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.splash,
  navigatorKey: _rootNavigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: Routes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: Routes.signIn,
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: Routes.signUp,
      builder: (context, state) => const SignUpPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return RouteWithNestedNavigation(navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorBlogKey,
          routes: [
            GoRoute(
              path: Routes.blog,
              builder: (context, state) => const BlogPage(),
              routes: [
                GoRoute(
                  path: Routes.blogManage,
                  builder:
                      (context, state) => ManageBlogPage(state.extra as Blog?),
                ),
                GoRoute(
                  path: Routes.blogSingle,
                  builder:
                      (context, state) => SingleBlogPage(state.extra as Blog),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
            GoRoute(
              path: Routes.profile,
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
  refreshListenable: StreamToListenable([sl<UserCubit>().stream]),
  redirect: (context, state) {
    final route = state.uri.path;
    final userState = sl<UserCubit>().state;
    final isUser = userState is UserSuccess;

    final isAuthPages = route == Routes.signIn || route == Routes.signUp;
    final isSplashPage = route == Routes.splash;

    if (!isUser && !isAuthPages && !isSplashPage) return Routes.signIn;
    if (isUser && (isSplashPage || isAuthPages)) return Routes.blog;

    return null;
  },
);
