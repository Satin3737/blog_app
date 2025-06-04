import 'package:blog_app/features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  const BlogModel({
    required super.id,
    required super.authorId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.topics,
    required super.updatedAt,
    super.authorName,
  });

  factory BlogModel.fromEntity(Blog blog) {
    return BlogModel(
      id: blog.id,
      authorId: blog.authorId,
      title: blog.title,
      content: blog.content,
      imageUrl: blog.imageUrl,
      topics: blog.topics,
      updatedAt: blog.updatedAt,
      authorName: blog.authorName,
    );
  }

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'] ?? '',
      authorId: json['author_id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'] ?? '',
      topics: List<String>.from(json['topics'] ?? []),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now()),
      authorName: json['author_name'],
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'author_id': authorId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };

    if (authorName != null) {
      json['author_name'] = authorName as String;
    }

    return json;
  }

  BlogModel copyWith({
    String? id,
    String? authorId,
    String? title,
    String? content,
    String? imageUrl,
    List<String>? topics,
    DateTime? updatedAt,
    String? authorName,
  }) {
    return BlogModel(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
      authorName: authorName ?? this.authorName,
    );
  }
}
