import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/primary_button.dart';
import '../Configuration/style.dart';
import 'otp_page.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();
  bool _hasCheckedVersion = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned(
              child: Image.asset(
                'assets/images/Periwinkle.png',
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
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomLeft,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ✅ Logo Row (icon + text)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/images/green_logo.svg",
                        height: 40,
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        "assets/images/green_text_logo.svg",
                        height: 35,
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  Text('Enter Your Mobile Number',
                      style: fontStyles.headingStyle),
                  SizedBox(height: screenHeight * 0.015),
                  Text(
                    'Enter your mobile number to get started',
                    style: fontStyles.commonTextStyle,
                  ),
                  SizedBox(height: screenHeight * 0.025),

                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      hintText: 'Enter mobile number',
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.03,
                            top: screenHeight * 0.015),
                        child: Text('+91',
                            style: fontStyles.headingStyle
                                .copyWith(fontSize: 16, color: Colors.black)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                  ),

                  const Spacer(),

                  /// ✅ Continue Button
                  PrimaryButton(
                    text: 'Continue',
                    icon: SvgPicture.asset(
                        'assets/images/Arrow_Circle_Right.svg'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OtpPage(phone: _phoneController.text),
                        ),
                      );
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
