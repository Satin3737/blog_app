import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/blog_upload.dart';
import 'package:blog_app/features/blog/domain/usecases/fetch_all_blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final FetchAllBlogs _fetchAllBlogs;
  final BlogUpload _blogUpload;

  BlogBloc({
    required FetchAllBlogs fetchAllBlogs,
    required BlogUpload blogUpload,
  }) : _fetchAllBlogs = fetchAllBlogs,
       _blogUpload = blogUpload,
       super(BlogInitial()) {
    on<BlogEvent>((_, emit) => emit(BlogLoading()));
    on<BlogFetchedAllBlogs>(_onFetchedAllBlogs);
    on<BlogUploaded>(_onBlogUploaded);
  }

  void _onFetchedAllBlogs(
    BlogFetchedAllBlogs event,
    Emitter<BlogState> emit,
  ) async {
    try {
      final response = await _fetchAllBlogs(NoParams());

      response.fold(
        (failure) => emit(BlogFailure(failure.message)),
        (blogs) => emit(BlogFetchAllBlogsSuccess(blogs)),
      );
    } catch (e) {
      emit(BlogFailure(e.toString()));
    }
  }

  void _onBlogUploaded(BlogUploaded event, Emitter<BlogState> emit) async {
    try {
      final response = await _blogUpload(
        BlogUploadParams(
          image: event.image,
          title: event.title,
          content: event.content,
          topics: event.topics,
          authorId: event.authorId,
        ),
      );

      response.fold(
        (failure) => emit(BlogFailure(failure.message)),
        (blog) => emit(BlogUploadSuccess()),
      );
    } catch (e) {
      emit(BlogFailure(e.toString()));
    }
  }
}
