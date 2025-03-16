import 'package:flutter/material.dart';
import 'package:employe_manage/Configuration/app_animations.dart';
class CustomAnimation extends StatefulWidget {
  final String initialText;
  final double widthFactor;
  final double heightFactor;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color borderColor;
  final double borderRadius;

  const CustomAnimation({
    Key? key,
    required this.initialText,
    this.widthFactor = AnimationConfig.widthFactor,
    this.heightFactor = AnimationConfig.heightFactor,
    this.padding = AnimationConfig.defaultPadding,
    this.margin = AnimationConfig.defaultMargin,
    this.borderColor = AnimationConfig.defaultBorderColor,
    this.borderRadius = AnimationConfig.defaultBorderRadius,
  }) : super(key: key);

  @override
  _CustomAnime createState() => _CustomAnime();
}

class _CustomAnime extends State<CustomAnimation> {
  bool isClicked = false;

  void toggleColor() {
    setState(() {
      isClicked = !isClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      child: InkWell(
        onTap: toggleColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        splashColor: Colors.blue,
        child:

        Padding(
          padding: widget.padding,
          child: AnimatedContainer(
            duration: AnimationConfig.animationDuration, // Use config value
            width: screenWidth * widget.widthFactor,
            height: screenHeight * widget.heightFactor,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: isClicked ? AnimationConfig.defaultClickedColor : AnimationConfig.defaultUnclickedColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
            child: Text(
              widget.initialText,
              style: TextStyle(
                color: Colors.white,
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
