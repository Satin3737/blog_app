import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class BlogUpload implements UseCase<Blog, BlogUploadParams> {
  final BlogRepository blogRepository;

  const BlogUpload(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(BlogUploadParams params) async {
    return await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      topics: params.topics,
      authorId: params.authorId,
    );
  }
}

class BlogUploadParams {
  final File image;
  final String title;
  final String content;
  final List<String> topics;
  final String authorId;

  const BlogUploadParams({
    required this.image,
    required this.title,
    required this.content,
    required this.topics,
    required this.authorId,
  });
}
