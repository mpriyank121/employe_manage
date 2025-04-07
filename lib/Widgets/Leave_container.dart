import 'package:flutter/material.dart';
import '../Configuration/app_cards.dart';

class LeaveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? borderRadius;
  final double? height; // ✅ Added height parameter
  final double? width;
  const LeaveContainer({
    Key? key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding ?? LeaveContainerConfig.defaultPadding,
      decoration: ShapeDecoration(
        color: LeaveContainerConfig.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? LeaveContainerConfig.defaultBorderRadius),
          side: const BorderSide(
            color: Colors.grey, // ✅ Grey border
            width: 1.0,         // You can adjust width if needed
          ),
        ),
      ),
      child: child,
    );
  }

}
