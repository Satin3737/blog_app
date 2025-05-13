import 'dart:io';

import 'package:blog_app/core/constants/tables.dart';
import 'package:blog_app/core/error/exceptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteSource {
  Future<List<BlogModel>> fetchBlogs();

  Future<BlogModel> createBlog(BlogModel blog);

  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });

  Future<void> deleteBlog(BlogModel blog);
}

class BlogRemoteSourceImpl implements BlogRemoteSource {
  final SupabaseClient supabaseClient;

  const BlogRemoteSourceImpl(this.supabaseClient);

  @override
  Future<List<BlogModel>> fetchBlogs() async {
    try {
      final blogsData = await supabaseClient
          .from(Tables.blogs)
          .select('*, ${Tables.users} (name)')
          .order('updated_at', ascending: false);

      return blogsData
          .map(
            (blog) => BlogModel.fromJson(
              blog,
            ).copyWith(authorName: blog[Tables.users]['name']),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlogModel> createBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient
              .from(Tables.blogs)
              .insert(blog.toJson())
              .select()
              .single();

      return BlogModel.fromJson(blogData);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      final storage = supabaseClient.storage;
      await storage.from(Tables.blogImages).upload(blog.id, image);
      return storage.from(Tables.blogImages).getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteBlog(BlogModel blog) async {
    try {
      await supabaseClient.from(Tables.blogs).delete().eq('id', blog.id);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
