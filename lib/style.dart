import 'package:flutter/material.dart';

class fontStyles {
  static const TextStyle headingStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
    fontFamily: 'Roboto',
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    fontFamily: 'Roboto',
  );

  static const TextStyle subTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: Color(0xFF949494),
    fontFamily: 'Roboto',
  );
  static const TextStyle commonTextStyle = TextStyle(
    color: Color(0xFF666666),
    fontSize: 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
    height: 1,
  );
  static const TextStyle normalText = TextStyle(
    color: Color(0xFF212121),
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    height: 1.60,
  );


}

class ContainerCard extends StatelessWidget {
  final double widthFactor; // Percentage of screen width
  final double heightFactor; // Percentage of screen height
  final Widget child;
  final EdgeInsets padding;
  final Color borderColor;
  final double borderRadius;

  const ContainerCard({
    Key? key,
    this.widthFactor = 0.4, // Default: 50% of screen width
    this.heightFactor = 0.15, // Default: 30% of screen height
    required this.child,
    this.padding = const EdgeInsets.only(top: 35),
    this.borderColor = const Color(0xFFE6E6E6),
    this.borderRadius = 6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(

      width: screenWidth * widthFactor, // Responsive width
      height: screenHeight * heightFactor, // Responsive height
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: borderColor),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}

