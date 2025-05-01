part of 'blog_list_bloc.dart';

@immutable
sealed class BlogListEvent {
  const BlogListEvent();
}

final class BlogListFetched extends BlogListEvent {}
