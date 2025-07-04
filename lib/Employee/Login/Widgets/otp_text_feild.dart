import 'package:flutter/material.dart';

class OtpTextField extends StatefulWidget {
  final int otpLength;
  final void Function(String)? onCompleted;

  const OtpTextField({Key? key, this.otpLength = 6, this.onCompleted}) : super(key: key);

  @override
  _OtpTextFieldState createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.otpLength, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.otpLength, (index) {
        return Container(
          width: 40,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: TextField(
            controller: _controllers[index],
            keyboardType: TextInputType.number,
            maxLength: 1,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(counterText: ''),
            onChanged: (value) {
              if (value.length == 1 && index < widget.otpLength - 1) {
                FocusScope.of(context).nextFocus();
              }
              if (_controllers.every((c) => c.text.isNotEmpty)) {
                String otp = _controllers.map((controller) => controller.text).join();
                widget.onCompleted?.call(otp);
              }
            },
          ),
        );
      }),
    );
  }
}
