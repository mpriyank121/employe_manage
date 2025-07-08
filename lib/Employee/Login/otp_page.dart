import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../Configuration/style.dart';
import '../../Widgets/primary_button.dart';
import '../../Widgets/Resend_Button.dart';

class OtpPage extends StatelessWidget {
  final String phone;

  OtpPage({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              child: Image.asset(
                'assets/images/Periwinkle.png', // replace with your actual image path
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Image.asset(
                  'assets/images/Star2.png',
                  height: 175,
                  width: 175,
                  fit: BoxFit.contain, // or BoxFit.fill if needed
                  alignment: Alignment.bottomLeft,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.05),
                  Text('Enter the verification code sent to',
                      style: fontStyles.headingStyle),

                  SizedBox(height: 8),
                  Text(
                    phone,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text('Enter your mobile number to get started',
                      style: fontStyles.subTextStyle),
                  SizedBox(height: screenHeight * 0.04),

                  /// OTP TextField using PinCodeTextField
                  PinCodeTextField(
                    appContext: context,
                    length: 6,
                    obscureText: true,
                    obscuringCharacter: '*',
                    animationType: AnimationType.fade,
                    cursorColor: Colors.black,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      fieldHeight: 55,
                      fieldWidth: 45,
                      inactiveColor: Colors.grey.shade300,
                      activeColor: Colors.grey.shade500,
                      selectedColor: Colors.grey.shade500,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    enableActiveFill: false,
                    keyboardType: TextInputType.number,
                    onCompleted: (value) {
                      print("Entered OTP: $value");
                    },
                    onChanged: (value) {},
                  ),

                  SizedBox(height: screenHeight * 0.06),

                  ResendButton(
                    onResend: () {
                      // TODO: implement resend OTP logic
                    },
                  ),
                  Spacer(),
       PrimaryButton(
                  text: 'Continue',
                  icon:
                      SvgPicture.asset('assets/images/Arrow_Circle_Right.svg'),
                  onPressed: () {
                  Get.offAllNamed('/home');
                  },
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
   