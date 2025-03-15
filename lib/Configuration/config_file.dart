import 'package:flutter/material.dart';

/// 🌟 Common App Colors
class AppColors {
  static const Color primary = Color(0xFF3CAB88);
  static const Color secondary = Color(0xFFF25922);
  static const Color border = Color(0xFFE6E6E6);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.grey;
  static const Color backgroundLight = Colors.white;
}

/// 📏 Common Spacing & Padding
class AppSpacing {
  static EdgeInsets horizontal(BuildContext context) =>
      EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05);

  static EdgeInsets vertical(BuildContext context) =>
      EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02);

  static SizedBox small(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.height * 0.01);

  static SizedBox medium(BuildContext context) =>
      SizedBox(height: MediaQuery.of(context).size.height * 0.02);
}

/// 🔠 Common Text Styles
class AppTextStyles {
  static TextStyle textStyle({
    Color color = AppColors.textPrimary,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    String fontFamily = 'Roboto',
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: fontFamily,
    );
  }

  static final TextStyle heading = textStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static final TextStyle subText = textStyle(color: AppColors.textSecondary);
  static final TextStyle buttonText = textStyle(color: Colors.white, fontWeight: FontWeight.bold);
}

/// 🏠 Border & Decoration Configs
class AppBorders {
  static const double radius = 15.0;
  static const double borderWidth = 1.0;
  static const BorderSide borderSide = BorderSide(color: AppColors.border, width: borderWidth);

  static const BoxDecoration bottomBorder = BoxDecoration(
    border: Border(bottom: borderSide),
  );
}

/// 💎 Button Configurations
class PrimaryButtonConfig {
  static const Color color = AppColors.secondary;
  static const double borderRadius = 8.0;
  static const double widthFactor = 0.9;
  static const double heightFactor = 0.07;
  static const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 10, vertical: 5);
  static const Duration animationDuration = Duration(milliseconds: 300);
}

/// 📊 OTP Text Field Configuration
class OtpTextFieldConfig {
  static const Color background = AppColors.textSecondary;
  static const double widthFactor = 0.1;
  static const double heightFactor = 0.06;
  static const double fontSizeFactor = 0.022;
  static const Color textColor = Colors.white;
  static const Color borderColor = Colors.transparent;
}

class AnimationConfig {
  static const double widthFactor = 0.25;
  static const double heightFactor = 0.03;
  static const double defaultBorderRadius = 15.0;
  static const Color defaultBorderColor = AppColors.border;
  static const Color defaultClickedColor = AppColors.secondary;
  static const Color defaultUnclickedColor = Colors.grey;
  static const Duration animationDuration = Duration(milliseconds: 300);

  static const EdgeInsets defaultPadding = EdgeInsets.symmetric();
  static const EdgeInsets defaultMargin = EdgeInsets.symmetric();
}

/// 🌟 Tile Configuration
class TileConfig {
  static const Color backgroundColor = Colors.white24;
  static const Color borderColor = Color(0xFFE6E6E6);
  static final TextStyle headingStyle = AppTextStyles.heading;
  static final TextStyle subTextStyle = AppTextStyles.subText;
  static const EdgeInsets padding = EdgeInsets.all(10);
}

/// 🌟 Welcome Card Configuration
class WelcomeCardConfig {
  static const Color backgroundColor = AppColors.primary;
  static const double borderRadius = 8.0;
  static final TextStyle welcomeText = AppTextStyles.textStyle(color: AppColors.textPrimary);
  static final TextStyle nameText = AppTextStyles.textStyle(fontSize: 24, fontWeight: FontWeight.w500);
  static final TextStyle roleText = AppTextStyles.textStyle(fontWeight: FontWeight.w500);
}

/// 🌟 Bottom Card Configuration
class BottomCardConfig {
  static const Color backgroundColor = AppColors.backgroundLight;
  static const double borderRadius = 8.0;
  static const double separatorWidthFactor = 0.003;
  static const Color separatorColor = Colors.grey;
  static const double separatorHeightFactor = 0.08;
  static final TextStyle commonTextStyle = AppTextStyles.subText;
}

/// 🌟 Leave Card Configuration
class LeaveCardConfig {
  static const double borderRadius = 12.0;
  static const Color backgroundColor = Color(0xFFECF8F4);
  static const Color borderColor = Color(0xFF3CAB88);

  static EdgeInsets padding(BuildContext context) {
    return const EdgeInsets.symmetric(vertical: 1, horizontal: 1);
  }

  static EdgeInsets margin(BuildContext context) {
    return const EdgeInsets.symmetric(vertical: 1, horizontal: 1);
  }

  static double defaultWidth(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.3; // Default to 40% of screen width
  }

  static double defaultHeight(BuildContext context) {
    return MediaQuery.of(context).size.height * 0.07;  // Default fixed height
  }

  static TextStyle titleStyle(BuildContext context) {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey);
  }

  static TextStyle countStyle(BuildContext context) {
    return TextStyle(fontSize: 14, color: Colors.grey[700]);
  }
}
//ResendButton
class ResendButtonConfig {
  static const int timerDuration = 30; // Timer starts from 30 seconds
  static const Color borderColor = Colors.orange;
  static const Color textColor = Colors.grey;
  static const Color timerColor = Colors.orange;
  static const double borderRadius = 8.0;
  static const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 25, vertical: 15);
}