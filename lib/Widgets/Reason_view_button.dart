import 'package:flutter/material.dart';
import '../Configuration/app_buttons.dart';

class ReasonViewButton extends StatelessWidget {
  final String text;
  final Color? color;
  final VoidCallback onPressed;
  final double? heightFactor;
  final double? widthFactor;

  const ReasonViewButton({
    Key? key,
    required this.text,
    this.color,
    required this.onPressed,
    this.heightFactor,
    this.widthFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? AppConfig.defaultButtonColor;

    return FractionallySizedBox(
      heightFactor: heightFactor,
      widthFactor: widthFactor,
      child: SizedBox(
        height: 20,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: buttonColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: buttonColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
