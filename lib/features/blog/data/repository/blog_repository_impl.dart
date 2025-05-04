import 'dart:io';

import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/utils/connection_checker.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/data/sources/blog_local_source.dart';
import 'package:blog_app/features/blog/data/sources/blog_remote_source.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteSource blogRemoteSource;
  final BlogLocalSource blogLocalSource;
  final ConnectionChecker connectionChecker;

  const BlogRepositoryImpl({
    required this.blogRemoteSource,
    required this.blogLocalSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, List<Blog>>> fetchBlogList() async {
    try {
      if (!await connectionChecker.isConnected) {
        return Right(blogLocalSource.loadLocalBlogs());
      }

      final blogs = await blogRemoteSource.fetchBlogList();
      blogLocalSource.saveLocalBlogs(blogs);

      return Right(blogs);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required List<String> topics,
    required String authorId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return Left(Failure('No internet connection'));
      }

      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        authorId: authorId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final blog = await blogRemoteSource.uploadBlog(blogModel);

      return Right(blog);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
