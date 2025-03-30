import 'package:flutter/material.dart';
import '../Configuration/app_buttons.dart';

class ReasonViewButton extends StatelessWidget {
  final String text;
  final Color? color;
  final VoidCallback onPressed;

  const ReasonViewButton({
    Key? key,
    required this.text,
    this.color, // Optional text and border color
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppConfig.defaultButtonColor; // Default color

    return SizedBox(
      height: 16,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: buttonColor), // Border color same as text
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // Rectangular with rounded corners
          ),
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: buttonColor, // Text color matches the border
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
