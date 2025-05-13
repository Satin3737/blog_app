import 'package:blog_app/core/common/cubits/user/app_user_cubit.dart';
import 'package:blog_app/core/router/routes.dart';
import 'package:blog_app/core/utils/calc_reading_time.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/ui/bloc/blog_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;

  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    void onCardTap() {
      context.go('${Routes.blog}/${Routes.blogSingle}', extra: blog);
    }

    void onBlogEdit() {
      print('edit');
    }

    void onBlogDelete() {
      context.read<BlogBloc>().add(BlogDeleted(blog));
    }

    return GestureDetector(
      onTap: onCardTap,
      child: Stack(
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Chip(label: Text(blog.topics[index]));
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 8);
                        },
                        itemCount: blog.topics.length,
                      ),
                    ),
                    Text(
                      blog.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Text('${calcReadingTime(blog.content).toString()} min'),
              ],
            ),
          ),
          BlocBuilder<AppUserCubit, AppUserState>(
            builder: (context, state) {
              if ((state as AppUserLoggedIn).user.id == blog.authorId) {
                return Positioned(
                  bottom: 0,
                  right: 0,
                  child: PopupMenuButton(
                    itemBuilder:
                        (context) => [
                          PopupMenuItem(onTap: onBlogEdit, child: Text('Edit')),
                          PopupMenuItem(
                            onTap: onBlogDelete,
                            child: Text('Delete'),
                          ),
                        ],
                  ),
                );
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
