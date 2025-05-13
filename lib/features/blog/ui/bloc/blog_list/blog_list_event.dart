part of 'blog_list_bloc.dart';

@immutable
sealed class BlogListEvent {
  const BlogListEvent();
}

final class BlogListFetched extends BlogListEvent {}

final class BlogListDeleteBlog extends BlogListEvent {
  final Blog blog;

  const BlogListDeleteBlog(this.blog);
}
