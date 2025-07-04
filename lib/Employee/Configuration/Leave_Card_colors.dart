import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF3CAB88);
  static const Color secondary = Color(0xFFF25922);
  static const Color border = Color(0xFFE6E6E6);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.grey;
  static const Color backgroundLight = Colors.white;
}
class LeaveColors {
  static const present = Color(0xFFB2DFDB);
  static const absent = Color(0xFFE57373);
  static const halfDay = Color(0xFF64B5F6);
  static const sickLeave = Color(0xFF81C784);
  static const casualLeave = Color(0xFFFFF59D);
  static const earnedLeave = Color(0xFF9575CD); // Medium Purple
  static const off = Color(0xFFEF6C00);         // Light Orange
  static const holiday = Color(0xFF4DB6AC);
}
Color blendWithWhite(Color color, [double amount = 0.85]) {
  return Color.lerp(color, Colors.white, amount)!;
}


