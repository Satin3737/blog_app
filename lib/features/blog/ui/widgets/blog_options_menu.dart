import 'package:blog_app/core/common/cubits/user/app_user_cubit.dart';
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

    return BlocBuilder<AppUserCubit, AppUserState>(
      builder: (context, state) {
        if ((state as AppUserLoggedIn).user.id == blog.authorId) {
          return Positioned(
            bottom: 0,
            right: 0,
            child: PopupMenuButton(
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
                      children: [Icon(Icons.delete, size: 24), Text('Delete')],
                    ),
                  ),
                ];
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
