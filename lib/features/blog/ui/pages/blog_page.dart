import 'package:blog_app/core/common/widgets/linear_loader.dart';
import 'package:blog_app/core/router/routes.dart';
import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/ui/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/ui/widgets/blog_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  void _fetchBlogs() => context.read<BlogBloc>().add(BlogsFetched());

  void _onAddNewBlog() => context.go('${Routes.blog}/${Routes.blogManage}');

  @override
  void initState() {
    super.initState();
    _fetchBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlogBloc, BlogState>(
      listener: (context, state) {
        if (state.status == BlogStatus.failure) {
          showSnackBar(context, state.error);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Blog App'),
          actions: [
            IconButton(
              onPressed: _onAddNewBlog,
              icon: const Icon(Icons.add_rounded),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: BlocBuilder<BlogBloc, BlogState>(
              builder: (context, state) {
                return LinearLoader(
                  loading: state.status == BlogStatus.loading,
                );
              },
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async => _fetchBlogs(),
          child: BlocBuilder<BlogBloc, BlogState>(
            builder: (context, state) {
              if (state.status == BlogStatus.failure) {
                return Center(
                  child: TextButton(
                    onPressed: _fetchBlogs,
                    child: Text('Try again!'),
                  ),
                );
              }

              if (state.blogs.isEmpty) {
                return const Center(child: Text('No blogs'));
              }

              return ListView.separated(
                padding: EdgeInsets.all(16).copyWith(bottom: 32),
                itemBuilder: (context, index) {
                  return BlogCard(
                    blog: state.blogs[index],
                    color: switch (index % 3) {
                      0 => AppPallet.gradient1,
                      1 => AppPallet.gradient2,
                      _ => AppPallet.gradient3,
                    },
                  );
                },
                separatorBuilder:
                    (context, index) => const SizedBox(height: 16),
                itemCount: state.blogs.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
