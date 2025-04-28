import 'dart:io';

import 'package:blog_app/features/blog/domain/usecases/blog_upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogUpload blogUpload;

  BlogBloc({required this.blogUpload}) : super(BlogInitial()) {
    on<BlogEvent>((_, emit) => emit(BlogLoading()));
    on<BlogUploaded>(_onBlogUploaded);
  }

  void _onBlogUploaded(BlogUploaded event, Emitter<BlogState> emit) async {
    try {
      final response = await blogUpload(
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
        (blog) => emit(BlogSuccess()),
      );
    } catch (e) {
      emit(BlogFailure(e.toString()));
    }
  }
}
