import 'package:blog_app/core/cubits/connection/app_connection_cubit.dart';
import 'package:blog_app/core/features/user/ui/bloc/user_cubit.dart';
import 'package:blog_app/core/router/routes.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/ui/bloc/blog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BlogOptionsMenu extends StatelessWidget {
  final Blog blog;

  const BlogOptionsMenu({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    void onBlogEdit() {
      context.go('${Routes.blog}/${Routes.blogManage}', extra: blog);
    }

    void onBlogDelete() {
      context.read<BlogBloc>().add(BlogDeleted(blog));
    }

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserSuccess && state.user.id == blog.authorId) {
          return Positioned(
            bottom: 0,
            right: 0,
            child: BlocBuilder<AppConnectionCubit, AppConnectionState>(
              builder: (context, state) {
                return PopupMenuButton(
                  enabled: state is AppConnectionConnected,
                  menuPadding: EdgeInsets.zero,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        onTap: onBlogEdit,
                        child: const Row(
                          spacing: 8,
                          children: [Icon(Icons.edit, size: 24), Text('Edit')],
                        ),
                      ),
                      PopupMenuItem(
                        onTap: onBlogDelete,
                        child: const Row(
                          spacing: 8,
                          children: [
                            Icon(Icons.delete, size: 24),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ];
                  },
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
