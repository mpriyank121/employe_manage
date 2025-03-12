import 'package:flutter/material.dart';

//Custom anime
class CustomAnimation extends StatefulWidget {
  final String initialtext;
  final double widthFactor;
  final double heightFactor;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color borderColor;
  final double borderRadius;

  const CustomAnimation({
    Key? key,
    required this.initialtext,
    this.widthFactor = 0.25,
    this.heightFactor = 0.05,
    this.padding = const EdgeInsets.symmetric(),
    this.margin = const EdgeInsets.symmetric(),
    this.borderColor = const Color(0xFFE6E6E6),
    this.borderRadius = 15.0,
  }) : super(key: key);

  @override
  _CustomAnime createState() => _CustomAnime();
}

class _CustomAnime extends State<CustomAnimation> {
  bool isClicked = false; // Track state

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
        child: Padding(
          padding: widget.padding,
          child:  AnimatedContainer(
            duration: Duration(milliseconds: 300), // Smooth transition
            width: screenWidth*0.3,
            height: screenHeight*0.03,
            alignment: Alignment.center,
            decoration: ShapeDecoration( color: isClicked ? Color(0xFFF25922): Colors.white, // Toggle colors
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
            ),
            child: Text(
              isClicked ? widget.initialtext : widget.initialtext,
              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}