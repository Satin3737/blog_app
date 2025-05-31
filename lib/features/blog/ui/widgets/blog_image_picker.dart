import 'dart:io';

import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:blog_app/core/widgets/image_loader.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class BlogImagePicker extends StatelessWidget {
  final Function() onImageSelect;
  final File? selectedImage;
  final Blog? blog;

  const BlogImagePicker({
    super.key,
    required this.onImageSelect,
    this.selectedImage,
    this.blog,
  });

  @override
  Widget build(BuildContext context) {
    final isEdit = blog != null;

    return GestureDetector(
      onTap: onImageSelect,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child:
            !isEdit && selectedImage == null
                ? DottedBorder(
                  color: AppPallet.border,
                  dashPattern: [16, 8],
                  radius: const Radius.circular(12),
                  borderType: BorderType.RRect,
                  strokeCap: StrokeCap.round,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 16,
                      children: [
                        Icon(Icons.folder_open, size: 48),
                        Text(
                          'Select your image',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                )
                : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      isEdit && selectedImage == null
                          ? ImageLoader(
                            image: blog!.imageUrl,
                            updatedAt: blog?.updatedAt,
                          )
                          : Image.file(selectedImage!, fit: BoxFit.cover),
                ),
      ),
    );
  }
}
