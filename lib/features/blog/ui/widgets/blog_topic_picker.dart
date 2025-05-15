import 'package:blog_app/core/constants/lists.dart';
import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';

class BlogTopicPicker extends StatelessWidget {
  final List<String> selectedTopics;
  final Function(String) onTap;

  const BlogTopicPicker({
    super.key,
    required this.selectedTopics,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        itemCount: Lists.topics.length,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => SizedBox(width: 8),
        itemBuilder: (context, index) {
          final topic = Lists.topics[index];
          final isSelected = selectedTopics.contains(topic);
          return GestureDetector(
            onTap: () => onTap(topic),
            child: Chip(
              label: Text(topic),
              color: WidgetStateColor.resolveWith(
                (_) => isSelected ? AppPallet.gradient1 : AppPallet.background,
              ),
              side: BorderSide(
                color: isSelected ? AppPallet.transparent : AppPallet.border,
              ),
            ),
          );
        },
      ),
    );
  }
}
