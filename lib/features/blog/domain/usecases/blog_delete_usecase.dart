import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class BlogDeleteUseCase implements UseCase<void, BlogDeleteParams> {
  final BlogRepository blogRepository;

  const BlogDeleteUseCase(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(BlogDeleteParams params) async {
    return await blogRepository.deleteBlog(params.blog);
  }
}

class BlogDeleteParams {
  final Blog blog;

  const BlogDeleteParams(this.blog);
}
