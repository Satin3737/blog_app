import 'dart:io';

import 'package:blog_app/core/cubits/user/app_user_cubit.dart';
import 'package:blog_app/core/router/routes.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/snackbar_service.dart';
import 'package:blog_app/core/widgets/linear_loader.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/ui/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/ui/widgets/blog_field.dart';
import 'package:blog_app/features/blog/ui/widgets/blog_image_picker.dart';
import 'package:blog_app/features/blog/ui/widgets/blog_topic_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ManageBlogPage extends StatefulWidget {
  final Blog? blog;

  const ManageBlogPage(this.blog, {super.key});

  @override
  State<ManageBlogPage> createState() => _ManageBlogPageState();
}

class _ManageBlogPageState extends State<ManageBlogPage> {
  late final bool isEdit;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _selectedTopics = [];
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    isEdit = widget.blog != null;

    if (isEdit) {
      _titleController.text = widget.blog!.title;
      _contentController.text = widget.blog!.content;
      _selectedTopics.addAll(widget.blog!.topics);
    }
  }

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

    if (_selectedImage == null && !isEdit) {
      SnackBarService.showSnackBar(context, 'Please select an image');
      return;
    }

    if (_selectedTopics.isEmpty) {
      SnackBarService.showSnackBar(context, 'Please select at least one topic');
      return;
    }

    if (isEdit) {
      context.read<BlogBloc>().add(
        BlogEdited(
          id: widget.blog!.id,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          topics: _selectedTopics,
          authorId: widget.blog!.authorId,
          image: _selectedImage,
          oldImage: widget.blog!.imageUrl,
          authorName: widget.blog!.authorName,
        ),
      );
    } else {
      final authorId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      context.read<BlogBloc>().add(
        BlogCreated(
          image: _selectedImage!,
          title: _titleController.text.trim(),
          content: _contentController.text.trim(),
          topics: _selectedTopics,
          authorId: authorId,
        ),
      );
    }
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
        title: Text(isEdit ? 'Edit Blog' : 'Add New Blog'),
        actions: [
          IconButton(
            onPressed: _onSubmit,
            icon: const Icon(Icons.done_rounded),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: BlocBuilder<BlogBloc, BlogState>(
            builder: (context, state) {
              return LinearLoader(loading: state.status == BlogStatus.loading);
            },
          ),
        ),
      ),
      body: BlocListener<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state.status == BlogStatus.failure) {
            SnackBarService.showSnackBar(context, state.error);
          }
          if (state.status == BlogStatus.success) {
            SnackBarService.showSnackBar(
              context,
              'Blog ${isEdit ? 'updated' : 'uploaded'} successfully',
              SnackBarType.success,
            );
            context.go(Routes.blog);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 24,
              children: [
                BlogImagePicker(
                  onImageSelect: _onImageSelect,
                  selectedImage: _selectedImage,
                  blog: widget.blog,
                ),
                BlogTopicPicker(
                  selectedTopics: _selectedTopics,
                  onTap: _onChipTap,
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
      ),
    );
  }
}
