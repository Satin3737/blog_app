part of 'blog_list_bloc.dart';

enum BlogListStatus { initial, success, failure }

@immutable
final class BlogListState {
  const BlogListState({
    this.status = BlogListStatus.initial,
    this.blogs = const <Blog>[],
    this.error = '',
  });

  final BlogListStatus status;
  final List<Blog> blogs;
  final String error;

  BlogListState copyWith({
    BlogListStatus? status,
    List<Blog>? blogs,
    String? error,
  }) {
    return BlogListState(
      status: status ?? this.status,
      blogs: blogs ?? this.blogs,
      error: error ?? this.error,
    );
  }
}
