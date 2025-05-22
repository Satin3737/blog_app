import 'dart:io';

import 'package:blog_app/core/constants/messages.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/utils/connection_checker.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/data/sources/blog_local_source.dart';
import 'package:blog_app/features/blog/data/sources/blog_remote_source.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
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
  Future<Either<Failure, List<Blog>>> fetchBlogs() async {
    try {
      if (!await connectionChecker.isConnected) {
        return Right(blogLocalSource.loadLocalBlogs());
      }

      final blogs = await blogRemoteSource.fetchBlogs();
      blogLocalSource.saveLocalBlogs(blogs);

      return Right(blogs);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Blog>> createBlog({
    required File image,
    required String title,
    required String content,
    required List<String> topics,
    required String authorId,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return Left(Failure(Messages.noConnectionError));
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

      final blog = await blogRemoteSource.createBlog(blogModel);

      return Right(blog);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Blog>> editBlog({
    required String id,
    required File image,
    required String title,
    required String content,
    required List<String> topics,
    required String authorId,
    String? authorName,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return Left(Failure(Messages.noConnectionError));
      }

      BlogModel blogModel = BlogModel(
        id: id,
        authorId: authorId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
        authorName: authorName,
      );

      final imageUrl = await blogRemoteSource.updateBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);
      final response = await blogRemoteSource.editBlog(blogModel);
      final updatedBlog = response.copyWith(authorName: authorName);

      blogLocalSource.editLocalBlog(updatedBlog);

      return Right(updatedBlog);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Blog>> deleteBlog(Blog blog) async {
    try {
      if (!await connectionChecker.isConnected) {
        return Left(Failure(Messages.noConnectionError));
      }

      final blogModel = BlogModel.fromEntity(blog);
      blogRemoteSource.deleteBlog(blogModel);
      blogLocalSource.deleteLocalBlog(blogModel);

      return Right(blog);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, File>> getBlogImage(Blog blog) async {
    try {
      if (!await connectionChecker.isConnected) {
        return Left(Failure(Messages.noConnectionError));
      }

      final blogModel = BlogModel.fromEntity(blog);
      final image = await blogRemoteSource.getBlogImage(blogModel);

      return Right(image);
    } on ServerException catch (e) {
      return Left(Failure(e.message));
    }
  }
}
