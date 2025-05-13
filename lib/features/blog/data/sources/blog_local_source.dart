import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalSource {
  void saveLocalBlogs(List<BlogModel> blogs);

  List<BlogModel> loadLocalBlogs();

  void deleteLocalBlog(BlogModel blog);
}

class BlogLocalSourceImpl implements BlogLocalSource {
  final Box box;

  const BlogLocalSourceImpl(this.box);

  @override
  void saveLocalBlogs(List<BlogModel> blogs) {
    box.clear();

    box.write(() {
      for (int i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toJson());
      }
    });
  }

  @override
  List<BlogModel> loadLocalBlogs() {
    List<BlogModel> blogs = [];
    if (box.isEmpty) return blogs;

    box.read(() {
      for (int i = 0; i < box.length; i++) {
        blogs.add(BlogModel.fromJson(box.get(i.toString())));
      }
    });

    return blogs;
  }

  @override
  void deleteLocalBlog(BlogModel blog) {
    if (box.isEmpty) return;

    box.read(() {
      for (int i = 0; i < box.length; i++) {
        if (box.get(i.toString())['id'] == blog.id) {
          box.delete(i.toString());
          break;
        }
      }
    });
  }
}
