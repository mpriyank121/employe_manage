// config/app_text_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String defaultFont = 'Roboto';

  static TextStyle textStyle({
    Color color = AppColors.textPrimary,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: defaultFont,
    );
  }

  static final TextStyle heading = textStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static final TextStyle subText = textStyle(color: AppColors.textSecondary);
  static final TextStyle buttonText = textStyle(color: Colors.white, fontWeight: FontWeight.bold);
}
