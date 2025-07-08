import 'package:coreHrx_employeeapp/Employee/Login/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/primary_button.dart';
import 'package:flutter_svg/svg.dart';

import '../Configuration/style.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();
  bool _hasCheckedVersion = false;

  @override
  Widget build(BuildContext context) {
    if (!_hasCheckedVersion) {
      WidgetsBinding.instance.addPostFrameCallback((_) {});
      _hasCheckedVersion = true;
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        title: 'CoreHRx',
        leading: IconButton(
          icon: SvgPicture.asset(
            'assets/images/green_logo.svg',
            height: 50,
          ),
          onPressed: () {},
        ),
      ),
      body: Stack(
        children: [
          /// ✅ Background Image
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

          /// ✅ Foreground content (with padding and SafeArea)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HR Management App', style: fontStyles.commonTextStyle),
                SizedBox(height: screenHeight * 0.02),
                Text('Enter Your Mobile Number',
                    style: fontStyles.headingStyle),
                SizedBox(height: screenHeight * 0.015),
                Text(
                  'Enter your mobile number to get started',
                  style: fontStyles.commonTextStyle,
                ),
                SizedBox(height: screenHeight * 0.025),

                /// Phone Number Field
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    hintText: 'Enter your mobile number',
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                          left: screenWidth * 0.03, top: screenHeight * 0.015),
                      child: Text('+91', style: fontStyles.headingStyle),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.025),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                ),

                Spacer(),

                /// Continue Button
                PrimaryButton(
                  text: 'Continue',
                  icon:
                      SvgPicture.asset('assets/images/Arrow_Circle_Right.svg'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OtpPage(phone: _phoneController.text)),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
