import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import missing package

class CategoryIcon extends StatelessWidget {
  final String initialText;
  final String assetPath; // Define assetPath as a class field
  final Color bgColor; // Add a background color parameter
  final double screenHeight; // Accept screenHeight

  const CategoryIcon({
    Key? key,
    required this.initialText,
    required this.assetPath,
    required this.bgColor,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: bgColor,
          child: IconButton(
            icon: SvgPicture.asset(
              assetPath,
              width: 30,
              height: screenHeight * 0.1,
            ),
            onPressed: () {
              print("$initialText icon pressed");
            },
          ),
        ),
        SizedBox(height: 5), // Space between icon and text
        Text(
          initialText, // Display the category name below the icon
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
