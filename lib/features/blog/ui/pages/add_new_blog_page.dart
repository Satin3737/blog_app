import 'dart:io';

import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/blog/ui/widgets/blog_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

const topics = [
  'Technology',
  'Health',
  'Science',
  'Travel',
  'Business',
  'Lifestyle',
  'Education',
  'Food',
];

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _selectedTopics = [];
  File? _selectedImage;

  void onImageSelect() async {
    final image = await pickImageFromGallery();
    if (image != null) setState(() => _selectedImage = image);
  }

  void onChipTap(String topic) {
    setState(() {
      if (_selectedTopics.contains(topic)) {
        _selectedTopics.remove(topic);
      } else {
        _selectedTopics.add(topic);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Blog'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.done_rounded)),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 24,
            children: [
              GestureDetector(
                onTap: onImageSelect,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child:
                      _selectedImage == null
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
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                ),
              ),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  itemCount: topics.length,
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final topic = topics[index];
                    final isSelected = _selectedTopics.contains(topic);

                    return GestureDetector(
                      onTap: () => onChipTap(topic),
                      child: Chip(
                        label: Text(topic),
                        color: WidgetStateColor.resolveWith(
                          (_) =>
                              isSelected
                                  ? AppPallet.gradient1
                                  : AppPallet.background,
                        ),
                        side: BorderSide(
                          color:
                              isSelected
                                  ? AppPallet.transparent
                                  : AppPallet.border,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Column(
                spacing: 16,
                children: [
                  BlogField(
                    controller: _titleController,
                    hintText: 'Blog Title',
                  ),
                  BlogField(
                    controller: _contentController,
                    hintText: 'Blog Content',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
