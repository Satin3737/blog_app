import 'dart:io';

import 'package:blog_app/features/blog/domain/usecases/blog_upload.dart';
import 'package:blog_app/features/blog/ui/bloc/blog_list/blog_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_upload_event.dart';
part 'blog_upload_state.dart';

class BlogUploadBloc extends Bloc<BlogUploadEvent, BlogUploadState> {
  final BlogUpload _blogUpload;
  final BlogListBloc _blogListBloc;

  BlogUploadBloc({
    required BlogUpload blogUpload,
    required BlogListBloc blogListBloc,
  }) : _blogUpload = blogUpload,
       _blogListBloc = blogListBloc,
       super(BlogUploadInitial()) {
    on<BlogUploadEvent>((_, emit) => emit(BlogUploadLoading()));
    on<BlogUploaded>(_onBlogUploaded);
  }

  void _onBlogUploaded(
    BlogUploaded event,
    Emitter<BlogUploadState> emit,
  ) async {
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

      response.fold((failure) => emit(BlogUploadFailure(failure.message)), (
        blog,
      ) {
        emit(BlogUploadSuccess());
        _blogListBloc.add(BlogListFetched());
      });
    } catch (e) {
      emit(BlogUploadFailure(e.toString()));
    }
  }
}
