import 'package:flutter/material.dart';
import '../Configuration/app_cards.dart';

class LeaveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? borderRadius;

  const LeaveContainer({
    Key? key,
    required this.child,
    this.padding,
    this.color,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? LeaveContainerConfig.defaultPadding,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: const Color(0xFFB3B3B3),
          ),
          borderRadius: BorderRadius.circular(borderRadius ?? LeaveContainerConfig.defaultBorderRadius),
        ),
      ),
      child: child,
    );
  }
}
