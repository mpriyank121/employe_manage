import 'package:employe_manage/Configuration/config_file.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading; // Custom leading widget
  final String? title;
  final Widget? trailing;// Custom title widget
  final List<Widget>? actions; // Custom actions

  const CustomAppBar({
    Key? key,
    this.leading = const SizedBox(),
    this.title,
    this.actions,
    this.trailing = const SizedBox(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: AppBorders.bottomBorder,
      child: AppBar(

        leading: leading ??
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              },
            ),
        title:
        Text(title ?? "",),
        centerTitle: true,
        actions: [ if (actions != null) ...actions!,
// Add existing actions
          trailing ?? IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications),
          ),]
    ),);
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
