import 'package:flutter/material.dart';

import 'app_colors.dart';

sealed class AppTextStyles {
  const AppTextStyles._();

  static const _defaultColor = AppColors.cBlack;

  static const size20Bold = TextStyle(
    fontSize: 20,
    color: _defaultColor,
    fontWeight: .w700,
  );
}
