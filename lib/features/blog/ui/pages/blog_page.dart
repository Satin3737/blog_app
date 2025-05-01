import 'package:blog_app/core/router/routes.dart';
import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/ui/bloc/blog_list/blog_list_bloc.dart';
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
  void _fetchBlogList() => context.read<BlogListBloc>().add(BlogListFetched());
  void _onAddNewBlog() => context.go('${Routes.blog}/${Routes.blogNew}');

  @override
  void initState() {
    super.initState();
    _fetchBlogList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: BlocBuilder<BlogListBloc, BlogListState>(
            builder: (context, state) {
              return AnimatedOpacity(
                opacity: state.status == BlogListStatus.initial ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: const LinearProgressIndicator(),
              );
            },
          ),
        ),
      ),
      body: BlocConsumer<BlogListBloc, BlogListState>(
        listener: (context, state) {
          if (state.status == BlogListStatus.failure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state.status == BlogListStatus.failure) {
            return Center(
              child: TextButton(
                onPressed: _fetchBlogList,
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
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: state.blogs.length,
          );
        },
      ),
    );
  }
}
