import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/fetch_blog_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_list_event.dart';
part 'blog_list_state.dart';

class BlogListBloc extends Bloc<BlogListEvent, BlogListState> {
  final FetchBlogList _fetchBlogList;

  BlogListBloc(FetchBlogList fetchBlogList)
    : _fetchBlogList = fetchBlogList,
      super(const BlogListState()) {
    on<BlogListFetched>(_onBlogListFetched);
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
}
