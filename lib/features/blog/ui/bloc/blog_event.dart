part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {
  const BlogEvent();
}

final class BlogUploaded extends BlogEvent {
  final String title;
  final String content;
  final File image;
  final List<String> topics;
  final String authorId;

  const BlogUploaded({
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
    required this.authorId,
  });
}
