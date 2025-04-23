import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onPressed;
  final double? widthFactor; // Optional width factor

  const ActionButton({
    Key? key,
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.onPressed,
    this.widthFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double? buttonWidth = widthFactor != null
        ? screenWidth * widthFactor!
        : null; // if widthFactor is not given, width will wrap content

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonWidth,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
