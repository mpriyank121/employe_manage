import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatefulWidget {
  final double widthFactor;
  final double heightFactor;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color borderColor;
  final double borderRadius;

  const CustomButton({
    Key? key,
    this.widthFactor = 0.25,
    this.heightFactor = 0.04,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    this.borderColor = const Color(0xFFE6E6E6),
    this.borderRadius = 15.0,
  }) : super(key: key);

  @override
  _CustomButton createState() => _CustomButton();
}

class _CustomButton extends State<CustomButton> {
  bool isApproved = false; // Track state

  void toggleStatus() {
    setState(() {
      isApproved = !isApproved;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * widget.widthFactor,
      height: screenHeight * widget.heightFactor,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: isApproved ? Colors.green : Colors.orange, // Toggle color
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(color: widget.borderColor, width: 2),

      ),
      child: InkWell(
        onTap: toggleStatus,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        splashColor: Colors.white24,
        child: Padding(
          padding: widget.padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isApproved ? "Approved" : "Pending",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              SizedBox(width: 8),
              SvgPicture.asset(
                isApproved
                    ? 'assets/icons/check.svg'
                    : 'assets/icons/pending.svg', // Change icon dynamically
                height: 16,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//Custom anime
class customanime extends StatefulWidget {
  final String initialtext;
  final double widthFactor;
  final double heightFactor;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color borderColor;
  final double borderRadius;

  const customanime({
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
  _customanime createState() => _customanime();
}

class _customanime extends State<customanime> {
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

//MainButton
class MainButton extends StatefulWidget {
  final String initialtext;
  final double widthFactor;
  final double heightFactor;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color borderColor;
  final double borderRadius;

  const MainButton({
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
  _customanime createState() => _customanime();
}

class _MainButton extends State<MainButton> {
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

