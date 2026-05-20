import 'package:flutter/material.dart';

import 'app_colors.dart';

sealed class AppTextStyles {
  const AppTextStyles._();

  static const _defaultColor = AppColors.cBlack;

  static const size14Regular = TextStyle(
    fontSize: 14,
    color: _defaultColor,
    fontWeight: .w400,
  );

  static const size14Medium = TextStyle(
    fontSize: 14,
    color: _defaultColor,
    fontWeight: .w500,
  );

  static const size16Bold = TextStyle(
    fontSize: 16,
    color: _defaultColor,
    fontWeight: .w700,
  );
  static const size20Bold = TextStyle(
    fontSize: 20,
    color: _defaultColor,
    fontWeight: .w700,
  );
}
