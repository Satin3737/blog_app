import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/blog_create.dart';
import 'package:blog_app/features/blog/domain/usecases/blog_delete.dart';
import 'package:blog_app/features/blog/domain/usecases/blog_edit.dart';
import 'package:blog_app/features/blog/domain/usecases/blog_get_image.dart';
import 'package:blog_app/features/blog/domain/usecases/blogs_fetch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogsFetch _blogsFetch;
  final BlogCreate _blogCreate;
  final BlogEdit _blogEdit;
  final BlogDelete _blogDelete;
  final BlogGetImage _blogGetImage;

  BlogBloc({
    required BlogsFetch blogsFetch,
    required BlogCreate blogCreate,
    required BlogEdit blogEdit,
    required BlogDelete blogDelete,
    required BlogGetImage blogGetImage,
  }) : _blogsFetch = blogsFetch,
       _blogCreate = blogCreate,
       _blogEdit = blogEdit,
       _blogDelete = blogDelete,
       _blogGetImage = blogGetImage,
       super(const BlogState()) {
    on<BlogEvent>(_onLoadingStarted);
    on<BlogsFetched>(_onBlogsFetched);
    on<BlogCreated>(_onBlogCreated);
    on<BlogEdited>(_onBlogEdited);
    on<BlogDeleted>(_onBlogDeleted);
    on<BlogImageFetched>(_onBlogImageFetched);
  }

  void _onLoadingStarted(BlogEvent event, Emitter<BlogState> emit) {
    emit(state.copyWith(status: BlogStatus.loading));
  }

  void _onBlogsFetched(BlogsFetched event, Emitter<BlogState> emit) async {
    try {
      final response = await _blogsFetch(NoParams());

      response.fold(
        (failure) => emit(
          state.copyWith(status: BlogStatus.failure, error: failure.message),
        ),
        (blogs) =>
            emit(state.copyWith(status: BlogStatus.success, blogs: blogs)),
      );
    } catch (e) {
      emit(state.copyWith(status: BlogStatus.failure, error: e.toString()));
    }
  }

  void _onBlogCreated(BlogCreated event, Emitter<BlogState> emit) async {
    try {
      final response = await _blogCreate(
        BlogCreateParams(
          image: event.image,
          title: event.title,
          content: event.content,
          topics: event.topics,
          authorId: event.authorId,
        ),
      );

      response.fold(
        (failure) => emit(
          state.copyWith(status: BlogStatus.failure, error: failure.message),
        ),
        (blog) {
          emit(
            state.copyWith(
              status: BlogStatus.success,
              blogs: [blog, ...state.blogs],
            ),
          );
        },
      );

      add(BlogsFetched());
    } catch (e) {
      emit(state.copyWith(status: BlogStatus.failure, error: e.toString()));
    }
  }

  void _onBlogEdited(BlogEdited event, Emitter<BlogState> emit) async {
    try {
      final response = await _blogEdit(
        BlogEditParams(
          id: event.id,
          image: event.image,
          title: event.title,
          content: event.content,
          topics: event.topics,
          authorId: event.authorId,
          authorName: event.authorName,
        ),
      );

      response.fold(
        (failure) => emit(
          state.copyWith(status: BlogStatus.failure, error: failure.message),
        ),
        (blog) {
          emit(
            state.copyWith(
              status: BlogStatus.success,
              blogs:
                  state.blogs.map((b) => b.id == blog.id ? blog : b).toList()
                    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt)),
            ),
          );
        },
      );

      add(BlogsFetched());
    } catch (e) {
      emit(state.copyWith(status: BlogStatus.failure, error: e.toString()));
    }
  }

  void _onBlogDeleted(BlogDeleted event, Emitter<BlogState> emit) async {
    try {
      final response = await _blogDelete(BlogDeleteParams(event.blog));

      response.fold(
        (failure) => emit(
          state.copyWith(status: BlogStatus.failure, error: failure.message),
        ),
        (blog) => emit(
          state.copyWith(
            status: BlogStatus.success,
            blogs: state.blogs.where((b) => b.id != blog.id).toList(),
          ),
        ),
      );

      add(BlogsFetched());
    } catch (e) {
      emit(state.copyWith(status: BlogStatus.failure, error: e.toString()));
    }
  }

  void _onBlogImageFetched(
    BlogImageFetched event,
    Emitter<BlogState> emit,
  ) async {
    try {
      final response = await _blogGetImage(BlogGetImageParams(event.blog));

      response.fold(
        (failure) => emit(
          state.copyWith(status: BlogStatus.failure, error: failure.message),
        ),
        (image) => emit(
          state.copyWith(status: BlogStatus.initial, currentImage: image),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: BlogStatus.failure, error: e.toString()));
    }
  }
}
