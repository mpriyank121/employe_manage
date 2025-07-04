import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Configuration/style.dart';
import 'Widgets/otp_text_feild.dart';
import '../../Widgets/primary_button.dart';
import '../../Widgets/Resend_Button.dart';

class OtpPage extends StatelessWidget {
  final String phone; // Accept phone as a parameter

  OtpPage({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.05),
            Text('Enter OTP', style: fontStyles.headingStyle),
            SizedBox(height: screenHeight * 0.02),
            OtpTextField(),
            SizedBox(height: screenHeight * 0.02),
            PrimaryButton(
              text: 'Verify',
              icon: Icon(Icons.check, color: Colors.white),
              onPressed: (){
                Get.offAllNamed('/home');
              }, // Disabled
            ),
            SizedBox(height: screenHeight * 0.02),
            ResendButton(
               onResend: () {  }, // Disabled
            ),
          ],
        ),
      ),
    ));
  }
}
