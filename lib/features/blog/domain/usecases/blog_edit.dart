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
      title: params.title,
      content: params.content,
      topics: params.topics,
      authorId: params.authorId,
      image: params.image,
      oldImage: params.oldImage,
      authorName: params.authorName,
    );
  }
}

class BlogEditParams {
  final String id;
  final String title;
  final String content;
  final List<String> topics;
  final String authorId;
  final File? image;
  final String? oldImage;
  final String? authorName;

  const BlogEditParams({
    required this.id,
    required this.title,
    required this.content,
    required this.topics,
    required this.authorId,
    this.image,
    this.oldImage,
    this.authorName,
  });
}
