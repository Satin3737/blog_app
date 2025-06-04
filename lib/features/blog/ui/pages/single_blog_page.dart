import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:blog_app/core/utils/calc_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/core/widgets/image_loader.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class SingleBlogPage extends StatelessWidget {
  final Blog blog;

  const SingleBlogPage(this.blog, {super.key});

  @override
  Widget build(BuildContext context) {
    const descrTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppPallet.grey,
    );

    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        interactive: true,
        thickness: 2,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16).copyWith(bottom: 32),
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blog.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'By ${blog.authorName ?? 'Unknown'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatDate(blog.updatedAt), style: descrTextStyle),
                      Text(
                        '${calcReadingTime(blog.content)} min read',
                        style: descrTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ImageLoader(
                    image: blog.imageUrl,
                    updatedAt: blog.updatedAt,
                  ),
                ),
              ),
              Text(
                blog.content,
                style: const TextStyle(fontSize: 16, height: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
