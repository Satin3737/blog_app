import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';

enum SnackBarType { success, info, error }

void showSnackBar(
  BuildContext context,
  String message, [
  SnackBarType type = SnackBarType.error,
]) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: AppPallet.white)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: switch (type) {
          SnackBarType.success => AppPallet.gradient1,
          SnackBarType.info => AppPallet.gradient2,
          SnackBarType.error => AppPallet.error,
        },
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
}
