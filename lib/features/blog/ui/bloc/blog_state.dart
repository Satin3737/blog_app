part of 'blog_bloc.dart';

enum BlogStatus { loading, success, failure }

@immutable
final class BlogState {
  const BlogState({
    this.status = BlogStatus.loading,
    this.blogs = const <Blog>[],
    this.error = '',
  });

  final BlogStatus status;
  final List<Blog> blogs;
  final String error;

  BlogState copyWith({BlogStatus? status, List<Blog>? blogs, String? error}) {
    return BlogState(
      status: status ?? this.status,
      blogs: blogs ?? this.blogs,
      error: error ?? this.error,
    );
  }
}
