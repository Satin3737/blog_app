import 'package:equatable/equatable.dart';

class Blog extends Equatable {
  final String id;
  final String authorId;
  final String title;
  final String content;
  final String imageUrl;
  final List<String> topics;
  final DateTime updatedAt;
  final String? authorName;

  const Blog({
    required this.id,
    required this.authorId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
    required this.updatedAt,
    this.authorName,
  });

  @override
  List<Object?> get props => [
    id,
    authorId,
    title,
    content,
    imageUrl,
    topics,
    updatedAt,
    authorName,
  ];
}
