import 'package:coreHrx_employeeapp/Employee/Configuration/style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Employee/Configuration/app_borders.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String? title;
  final Widget? trailing;
  final List<Widget>? actions;
  final bool showBackButton;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    Key? key,
    this.leading,
    this.title,
    this.actions,
    this.showBackButton = true,
    this.centerTitle = true,
    this.trailing,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppBorders.bottomBorder,
      child: AppBar(
        backgroundColor: Colors.white,
        leading: leading ??
            (showBackButton
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                  )
                : null),
        title: Text(title ?? "", style: fontStyles.headingStyle),
        centerTitle: centerTitle,
        actions: [
          if (trailing != null) trailing!,
          if (actions != null) ...actions!,
        ],
        bottom: bottom,
      ),
    );
  }

  @override
  Size get preferredSize {
    final bottomHeight = bottom?.preferredSize.height ?? 0.0;
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}
