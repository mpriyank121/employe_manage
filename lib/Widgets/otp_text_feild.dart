import 'package:flutter/material.dart';

class OtpTextField extends StatefulWidget {
  const OtpTextField({Key? key}) : super(key: key);

  @override
  _OtpTextFieldState createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 40, // Adjust width based on design
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey, // Ensure good contrast
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white),
      ),
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1, // Allows only one digit
        style: TextStyle(fontSize: 22, color: Colors.white), // Ensure text is visible
        decoration: InputDecoration(
          counterText: '', // Remove character count indicator
          border: InputBorder.none,
        ),
      ),
    );
  }
}
