import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';

class ImageLoader extends StatelessWidget {
  final String image;
  final DateTime? updatedAt;

  const ImageLoader({super.key, required this.image, this.updatedAt});

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: '',
      image: '$image?${updatedAt?.millisecondsSinceEpoch ?? ''}',
      fit: BoxFit.cover,
      placeholderErrorBuilder: (_, __, ___) => const Loader(),
      imageErrorBuilder: (_, __, ___) {
        return Icon(Icons.broken_image, color: AppPallet.grey, size: 64);
      },
    );
  }
}
