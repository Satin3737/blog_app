part of 'blog_upload_bloc.dart';

@immutable
sealed class BlogUploadState {
  const BlogUploadState();
}

final class BlogUploadInitial extends BlogUploadState {}

final class BlogUploadLoading extends BlogUploadState {}

final class BlogUploadSuccess extends BlogUploadState {}

final class BlogUploadFailure extends BlogUploadState {
  final String message;

  const BlogUploadFailure(this.message);
}
