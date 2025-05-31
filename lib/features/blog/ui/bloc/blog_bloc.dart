import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/blog_create_usecase.dart';
import 'package:blog_app/features/blog/domain/usecases/blog_delete_usecase.dart';
import 'package:blog_app/features/blog/domain/usecases/blog_edit_usecase.dart';
import 'package:blog_app/features/blog/domain/usecases/blogs_fetch_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogsFetchUseCase _blogsFetchUseCase;
  final BlogCreateUseCase _blogCreateUseCase;
  final BlogEditUseCase _blogEditUseCase;
  final BlogDeleteUseCase _blogDeleteUseCase;

  BlogBloc({
    required BlogsFetchUseCase blogsFetchUseCase,
    required BlogCreateUseCase blogCreateUseCase,
    required BlogEditUseCase blogEditUseCase,
    required BlogDeleteUseCase blogDeleteUseCase,
  }) : _blogsFetchUseCase = blogsFetchUseCase,
       _blogCreateUseCase = blogCreateUseCase,
       _blogEditUseCase = blogEditUseCase,
       _blogDeleteUseCase = blogDeleteUseCase,
       super(const BlogState()) {
    on<BlogEvent>(_onLoadingStarted);
    on<BlogsFetched>(_onBlogsFetched);
    on<BlogCreated>(_onBlogCreated);
    on<BlogEdited>(_onBlogEdited);
    on<BlogDeleted>(_onBlogDeleted);
  }

  void _onLoadingStarted(BlogEvent event, Emitter<BlogState> emit) {
    emit(state.copyWith(status: BlogStatus.loading));
  }

  void _onBlogsFetched(BlogsFetched event, Emitter<BlogState> emit) async {
    try {
      final response = await _blogsFetchUseCase(NoParams());

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
      final response = await _blogCreateUseCase(
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

          add(BlogsFetched());
        },
      );
    } catch (e) {
      emit(state.copyWith(status: BlogStatus.failure, error: e.toString()));
    }
  }

  void _onBlogEdited(BlogEdited event, Emitter<BlogState> emit) async {
    try {
      final response = await _blogEditUseCase(
        BlogEditParams(
          id: event.id,
          title: event.title,
          content: event.content,
          topics: event.topics,
          authorId: event.authorId,
          image: event.image,
          oldImage: event.oldImage,
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

          add(BlogsFetched());
        },
      );
    } catch (e) {
      emit(state.copyWith(status: BlogStatus.failure, error: e.toString()));
    }
  }

  void _onBlogDeleted(BlogDeleted event, Emitter<BlogState> emit) async {
    try {
      final response = await _blogDeleteUseCase(BlogDeleteParams(event.blog));

      response.fold(
        (failure) => emit(
          state.copyWith(status: BlogStatus.failure, error: failure.message),
        ),
        (blog) {
          emit(
            state.copyWith(
              status: BlogStatus.success,
              blogs: state.blogs.where((b) => b.id != blog.id).toList(),
            ),
          );

          add(BlogsFetched());
        },
      );
    } catch (e) {
      emit(state.copyWith(status: BlogStatus.failure, error: e.toString()));
    }
  }
}
