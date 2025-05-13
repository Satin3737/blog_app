import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/blog_create.dart';
import 'package:blog_app/features/blog/domain/usecases/blog_delete.dart';
import 'package:blog_app/features/blog/domain/usecases/fetch_blogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogsFetch _blogsFetch;
  final BlogCreate _blogCreate;
  final BlogDelete _blogDelete;

  BlogBloc({
    required BlogsFetch blogsFetch,
    required BlogCreate blogCreate,
    required BlogDelete blogDelete,
  }) : _blogsFetch = blogsFetch,
       _blogCreate = blogCreate,
       _blogDelete = blogDelete,
       super(const BlogState()) {
    on<BlogsFetched>(_onBlogsFetched);
    on<BlogCreated>(_onBlogCreated);
    on<BlogDeleted>(_onBlogDeleted);
  }

  void _onBlogsFetched(BlogsFetched event, Emitter<BlogState> emit) async {
    emit(state.copyWith(status: BlogStatus.loading));

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
    emit(state.copyWith(status: BlogStatus.loading));

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
    } catch (e) {
      emit(state.copyWith(status: BlogStatus.failure, error: e.toString()));
    }
  }

  void _onBlogDeleted(BlogDeleted event, Emitter<BlogState> emit) async {
    emit(state.copyWith(status: BlogStatus.loading));

    try {
      final response = await _blogDelete(BlogDeleteParams(event.blog));

      response.fold(
        (failure) => emit(
          state.copyWith(status: BlogStatus.failure, error: failure.message),
        ),
        (_) => emit(
          state.copyWith(
            status: BlogStatus.success,
            blogs:
                state.blogs.where((blog) => blog.id != event.blog.id).toList(),
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: BlogStatus.failure, error: e.toString()));
    }
  }
}
