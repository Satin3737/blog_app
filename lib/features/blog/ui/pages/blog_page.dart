import 'package:blog_app/core/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    void onAddNewBlog() => context.go('${Routes.blog}/${Routes.blogNew}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Blog App'),
        actions: [
          IconButton(
            onPressed: onAddNewBlog,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
    );
  }
}
