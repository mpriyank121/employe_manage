import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Configuration/app_borders.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading; // Custom leading widget
  final String? title;
  final Widget? trailing; // Custom trailing widget
  final List<Widget>? actions; // Custom actions
  final bool showBackButton;
  final bool centerTitle;

  const CustomAppBar({
    Key? key,
    this.leading,
    this.title,
    this.actions,
    this.showBackButton = true, // Default: Show back button
    this.centerTitle = true,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppBorders.bottomBorder,
      child: AppBar(

        leading: leading ??
            (showBackButton
                ? IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Get.back(),
            )
                : null),
        title: Text(title ?? ""),
        centerTitle: centerTitle,
        actions: [
          if (trailing != null) trailing!, // Conditionally include trailing
          if (actions != null) ...actions!, // Add existing actions
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
