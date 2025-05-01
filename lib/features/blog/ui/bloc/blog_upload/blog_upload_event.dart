part of 'blog_upload_bloc.dart';

@immutable
sealed class BlogUploadEvent {
  const BlogUploadEvent();
}

final class BlogUploaded extends BlogUploadEvent {
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
