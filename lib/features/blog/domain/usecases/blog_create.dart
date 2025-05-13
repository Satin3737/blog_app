import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class BlogCreate implements UseCase<Blog, BlogCreateParams> {
  final BlogRepository blogRepository;

  const BlogCreate(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(BlogCreateParams params) async {
    return await blogRepository.createBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      topics: params.topics,
      authorId: params.authorId,
    );
  }
}

class BlogCreateParams {
  final File image;
  final String title;
  final String content;
  final List<String> topics;
  final String authorId;

  const BlogCreateParams({
    required this.image,
    required this.title,
    required this.content,
    required this.topics,
    required this.authorId,
  });
}
