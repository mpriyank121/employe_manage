// config/app_animations.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AnimationConfig {
  static const double widthFactor = 0.25;
  static const double heightFactor = 0.03;
  static const double defaultBorderRadius = 15.0;
  static const Color defaultBorderColor = AppColors.border;
  static const Color defaultClickedColor = AppColors.secondary;
  static const Color defaultUnclickedColor = Colors.grey;
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const EdgeInsets defaultPadding = EdgeInsets.zero;
  static const EdgeInsets defaultMargin = EdgeInsets.zero;
}
