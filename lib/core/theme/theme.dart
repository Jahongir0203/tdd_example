import 'package:flutter/material.dart';
import 'package:tdd_example/core/theme/app_colors.dart';
import 'package:tdd_example/core/theme/app_text_styles.dart';

sealed class AppTheme {
  static ThemeData light = ThemeData.light().copyWith(
    brightness: .light,
    scaffoldBackgroundColor: AppColors.cWhite,
    appBarTheme: AppBarThemeData(
      backgroundColor: AppColors.cBlueAccent,
      titleTextStyle: AppTextStyles.size20Bold.copyWith(
        color: AppColors.cWhite,
      ),
    ),
  );
}
