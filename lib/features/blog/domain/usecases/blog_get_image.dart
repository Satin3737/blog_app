import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class BlogGetImage implements UseCase<void, BlogGetImageParams> {
  final BlogRepository blogRepository;

  const BlogGetImage(this.blogRepository);

  @override
  Future<Either<Failure, File>> call(BlogGetImageParams params) async {
    return await blogRepository.getBlogImage(params.blog);
  }
}

class BlogGetImageParams {
  final Blog blog;

  const BlogGetImageParams(this.blog);
}
