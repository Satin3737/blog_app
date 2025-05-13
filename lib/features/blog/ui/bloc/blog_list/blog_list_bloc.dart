import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/blog_delete.dart';
import 'package:blog_app/features/blog/domain/usecases/fetch_blog_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_list_event.dart';
part 'blog_list_state.dart';

class BlogListBloc extends Bloc<BlogListEvent, BlogListState> {
  final FetchBlogList _fetchBlogList;
  final BlogDelete _blogDelete;

  BlogListBloc({
    required FetchBlogList fetchBlogList,
    required BlogDelete blogDelete,
  }) : _fetchBlogList = fetchBlogList,
       _blogDelete = blogDelete,
       super(const BlogListState()) {
    on<BlogListFetched>(_onBlogListFetched);
    on<BlogListDeleteBlog>(_onBlogListDeletedBlog);
  }

  void _onBlogListFetched(
    BlogListFetched event,
    Emitter<BlogListState> emit,
  ) async {
    emit(state.copyWith(status: BlogListStatus.loading));

    try {
      final response = await _fetchBlogList(NoParams());

      response.fold(
        (failure) => emit(
          state.copyWith(
            status: BlogListStatus.failure,
            error: failure.message,
          ),
        ),
        (blogs) =>
            emit(state.copyWith(status: BlogListStatus.success, blogs: blogs)),
      );
    } catch (e) {
      emit(state.copyWith(status: BlogListStatus.failure, error: e.toString()));
    }
  }

  void _onBlogListDeletedBlog(
    BlogListDeleteBlog event,
    Emitter<BlogListState> emit,
  ) async {
    emit(state.copyWith(status: BlogListStatus.loading));

    try {
      final response = await _blogDelete(BlogDeleteParams(event.blog));

      response.fold(
        (failure) => emit(
          state.copyWith(
            status: BlogListStatus.failure,
            error: failure.message,
          ),
        ),
        (_) => emit(
          state.copyWith(
            status: BlogListStatus.success,
            blogs:
                state.blogs.where((blog) => blog.id != event.blog.id).toList(),
          ),
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: BlogListStatus.failure, error: e.toString()));
    }
  }
}
