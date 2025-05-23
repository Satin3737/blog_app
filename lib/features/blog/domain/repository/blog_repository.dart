import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, List<Blog>>> fetchBlogs();

  Future<Either<Failure, Blog>> createBlog({
    required File image,
    required String title,
    required String content,
    required List<String> topics,
    required String authorId,
  });

  Future<Either<Failure, Blog>> editBlog({
    required String id,
    required String title,
    required String content,
    required List<String> topics,
    required String authorId,
    File? image,
    String? oldImage,
    String? authorName,
  });

  Future<Either<Failure, Blog>> deleteBlog(Blog blog);
}
