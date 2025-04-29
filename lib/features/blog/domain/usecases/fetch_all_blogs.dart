import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class FetchAllBlogs implements UseCase<List<Blog>, NoParams> {
  final BlogRepository blogRepository;

  const FetchAllBlogs(this.blogRepository);

  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await blogRepository.fetchAllBlogs();
  }
}
