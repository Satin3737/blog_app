import 'package:blog_app/core/theme/app_pallet.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _inputBorder({Color color = AppPallet.border}) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color, width: 2),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(backgroundColor: AppPallet.background),
    scaffoldBackgroundColor: AppPallet.background,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(24),
      enabledBorder: _inputBorder(),
      focusedBorder: _inputBorder(color: AppPallet.gradient2),
      errorBorder: _inputBorder(color: AppPallet.error),
      focusedErrorBorder: _inputBorder(color: AppPallet.error),
    ),
  );
}
