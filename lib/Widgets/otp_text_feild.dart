import 'package:flutter/material.dart';
import '/Configuration/config_file.dart';

class OtpTextField extends StatelessWidget {
  final OtpTextFieldConfig config;

  const OtpTextField({Key? key, this.config = const OtpTextFieldConfig()}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: config.backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: config.borderColor),
        ),
        child: SizedBox(
          width: config.width,
          height: config.height,
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: TextStyle(fontSize: config.fontSize, color: config.textColor),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
