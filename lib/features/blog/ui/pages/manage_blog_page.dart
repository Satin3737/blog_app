import 'dart:io';

import 'package:blog_app/core/common/cubits/user/app_user_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/lists.dart';
import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/ui/bloc/blog_upload/blog_upload_bloc.dart';
import 'package:blog_app/features/blog/ui/widgets/blog_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ManageBlogPage extends StatefulWidget {
  const ManageBlogPage({super.key});

  @override
  State<ManageBlogPage> createState() => _ManageBlogPageState();
}

class _ManageBlogPageState extends State<ManageBlogPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _selectedTopics = [];
  File? _selectedImage;

  void _onImageSelect() async {
    final image = await pickImageFromGallery();
    if (image != null) setState(() => _selectedImage = image);
  }

  void _onChipTap(String topic) {
    setState(() {
      if (_selectedTopics.contains(topic)) {
        _selectedTopics.remove(topic);
      } else {
        _selectedTopics.add(topic);
      }
    });
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedImage == null) {
      showSnackBar(context, 'Please select an image');
      return;
    }

    if (_selectedTopics.isEmpty) {
      showSnackBar(context, 'Please select at least one topic');
      return;
    }

    final authorId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

    context.read<BlogUploadBloc>().add(
      BlogUploaded(
        image: _selectedImage!,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        topics: _selectedTopics,
        authorId: authorId,
      ),
    );
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
          IconButton(
            onPressed: _onSubmit,
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: BlocConsumer<BlogUploadBloc, BlogUploadState>(
          listener: (context, state) {
            if (state is BlogUploadFailure) {
              showSnackBar(context, state.message);
            }
            if (state is BlogUploadSuccess) {
              showSnackBar(
                context,
                'Blog uploaded successfully',
                SnackBarType.success,
              );
              context.pop();
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                spacing: 24,
                children: [
                  GestureDetector(
                    onTap: _onImageSelect,
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
                      itemCount: Lists.topics.length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) => SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final topic = Lists.topics[index];
                        final isSelected = _selectedTopics.contains(topic);

                        return GestureDetector(
                          onTap: () => _onChipTap(topic),
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
                  if (state is BlogUploadLoading) const Loader(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
