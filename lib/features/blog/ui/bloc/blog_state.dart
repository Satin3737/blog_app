part of 'blog_bloc.dart';

enum BlogStatus { initial, loading, success, failure }

@immutable
final class BlogState {
  final BlogStatus status;
  final List<Blog> blogs;
  final String error;

  const BlogState({
    this.status = BlogStatus.initial,
    this.blogs = const <Blog>[],
    this.error = '',
  });

  BlogState copyWith({BlogStatus? status, List<Blog>? blogs, String? error}) {
    return BlogState(
      status: status ?? this.status,
      blogs: blogs ?? this.blogs,
      error: error ?? this.error,
    );
  }
}
