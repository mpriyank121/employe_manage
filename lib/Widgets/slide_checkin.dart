import 'package:flutter/material.dart';

class SlideCheckIn extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const SlideCheckIn({Key? key, required this.screenWidth, required this.screenHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.08,
      margin: const EdgeInsets.only(top: 15),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.05,
        vertical: screenHeight * 0.02,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: const Color(0x193CAB88),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF3CAB88)),
          borderRadius: BorderRadius.circular(81),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: screenWidth * 0.1,
            height: screenHeight * 0.05,
            decoration: const ShapeDecoration(
              color: Color(0xFF3CAB88),
              shape: OvalBorder(),
            ),
            child: const Icon(Icons.arrow_forward, color: Colors.white),
          ),
          Container(
            padding: const EdgeInsets.only(left: 70),
            child: const Text(
              'Slide to Check In',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
