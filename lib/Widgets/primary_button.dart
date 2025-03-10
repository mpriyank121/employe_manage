import 'package:flutter/material.dart';
import '../Configuration/config_file.dart';

class PrimaryButton extends StatefulWidget {
  final String initialtext;
  final VoidCallback? onPressed;
  final double? widthFactor;  // Allow custom width
  final double? heightFactor; // Allow custom height
  final Color? buttonColor;   // Allow custom button color

  const PrimaryButton({
    Key? key,
    required this.initialtext,
    this.onPressed,
    this.widthFactor,
    this.heightFactor,
    this.buttonColor,
  }) : super(key: key);

  @override
  _PrimaryButton createState() => _PrimaryButton();
}

class _PrimaryButton extends State<PrimaryButton> {
  bool isClicked = false;

  void toggleColor() {
    setState(() {
      isClicked = !isClicked;
    });
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      child: InkWell(
        onTap: toggleColor,
        borderRadius: BorderRadius.circular(PrimaryButtonConfig.borderRadius),
        splashColor: PrimaryButtonConfig.splashColor,
        child: Padding(
          padding: PrimaryButtonConfig.defaultPadding,
          child: AnimatedContainer(
            duration: PrimaryButtonConfig.animationDuration,
            width: screenWidth * (widget.widthFactor ?? PrimaryButtonConfig.buttonWidthFactor),
            height: screenHeight * (widget.heightFactor ?? PrimaryButtonConfig.buttonHeightFactor),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.buttonColor ?? PrimaryButtonConfig.primaryButtonColor, // Use custom color if provided
              borderRadius: BorderRadius.circular(PrimaryButtonConfig.borderRadius),
            ),
            child: Text(
              widget.initialtext,
              style: TextStyle(
                color: PrimaryButtonConfig.textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
