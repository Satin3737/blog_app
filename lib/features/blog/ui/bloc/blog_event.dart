part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {
  const BlogEvent();
}

final class BlogsFetched extends BlogEvent {}

final class BlogCreated extends BlogEvent {
  final String title;
  final String content;
  final File image;
  final List<String> topics;
  final String authorId;

  const BlogCreated({
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
    required this.authorId,
  });
}

final class BlogEdited extends BlogEvent {
  final String id;
  final String title;
  final String content;
  final List<String> topics;
  final String authorId;
  final File? image;
  final String? oldImage;
  final String? authorName;

  const BlogEdited({
    required this.id,
    required this.title,
    required this.content,
    required this.topics,
    required this.authorId,
    this.image,
    this.oldImage,
    this.authorName,
  });
}

final class BlogDeleted extends BlogEvent {
  final Blog blog;

  const BlogDeleted(this.blog);
}
