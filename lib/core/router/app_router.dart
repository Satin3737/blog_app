import 'package:blog_app/core/router/routes.dart';
import 'package:blog_app/features/auth/ui/pages/signin_page.dart';
import 'package:blog_app/features/auth/ui/pages/signup_page.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/ui/pages/blog_page.dart';
import 'package:blog_app/features/blog/ui/pages/manage_blog_page.dart';
import 'package:blog_app/features/blog/ui/pages/single_blog_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static GoRouter router(bool isCurrentUser) => GoRouter(
    initialLocation: Routes.signIn,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.signIn,
        builder: (context, state) => const SignInPage(),
      ),
      GoRoute(
        path: Routes.signUp,
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: Routes.blog,
        builder: (context, state) => const BlogPage(),
        routes: [
          GoRoute(
            path: Routes.blogManage,
            builder: (context, state) => ManageBlogPage(state.extra as Blog?),
          ),
          GoRoute(
            path: Routes.blogSingle,
            builder: (context, state) => SingleBlogPage(state.extra as Blog),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final route = state.uri.path;
      final isAuthPages = route == Routes.signIn || route == Routes.signUp;

      if (isCurrentUser && isAuthPages) return Routes.blog;
      if (!isCurrentUser && !isAuthPages) return Routes.signIn;

      return null;
    },
  );
}
