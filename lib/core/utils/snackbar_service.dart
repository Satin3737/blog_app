import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';

enum SnackBarType { success, info, error }

class SnackBarService {
  static final GlobalKey<ScaffoldMessengerState> rootMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showRootSnackBar(
    String message, [
    SnackBarType type = SnackBarType.error,
  ]) {
    rootMessengerKey.currentState
      ?..hideCurrentSnackBar
      ..showSnackBar(_triggerSnackBar(message, type));
  }

  static void showSnackBar(
    BuildContext context,
    String message, [
    SnackBarType type = SnackBarType.error,
  ]) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(_triggerSnackBar(message, type));
  }

  static SnackBar _triggerSnackBar(
    String message, [
    SnackBarType type = SnackBarType.error,
  ]) {
    return SnackBar(
      content: Text(message, style: const TextStyle(color: AppPallet.white)),
      behavior: SnackBarBehavior.floating,
      backgroundColor: switch (type) {
        SnackBarType.success => AppPallet.success,
        SnackBarType.info => AppPallet.info,
        SnackBarType.error => AppPallet.error,
      },
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
