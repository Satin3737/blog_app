import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class BlogEdit implements UseCase<void, BlogEditParams> {
  final BlogRepository blogRepository;

  const BlogEdit(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(BlogEditParams params) async {
    return await blogRepository.editBlog(
      id: params.id,
      image: params.image,
      title: params.title,
      content: params.content,
      topics: params.topics,
      authorId: params.authorId,
      authorName: params.authorName,
    );
  }
}

class BlogEditParams {
  final String id;
  final File image;
  final String title;
  final String content;
  final List<String> topics;
  final String authorId;
  final String? authorName;

  const BlogEditParams({
    required this.id,
    required this.image,
    required this.title,
    required this.content,
    required this.topics,
    required this.authorId,
    this.authorName,
  });
}
