import 'package:employe_manage/Screens/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Configuration/style.dart';
import '../widgets/app_bar.dart';
import '../widgets/primary_button.dart';
import '../api/api_service.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  /// ✅ Send OTP and Save Phone Number
  Future<void> sendOtp() async {
    String phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty || phoneNumber.length != 10) {
      Get.snackbar("Error", "Enter a valid 10-digit phone number", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool otpSent = await _apiService.sendOtp(phoneNumber);

    setState(() {
      _isLoading = false;
    });

    if (otpSent) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone', phoneNumber);
      print("📌 Phone number saved: $phoneNumber");

      Get.to(() => OtpPage()); // ✅ Navigate to OTP page
    } else {
      Get.snackbar("Error", "Failed to send OTP. Try again.", snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Bookchor',
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/bc 3.svg'),
          onPressed: () {},
        ),
        actions: [],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('HR Management App', style: fontStyles.commonTextStyle),
            SizedBox(height: screenHeight * 0.02),

            Text('Enter Your Mobile Number', style: fontStyles.headingStyle),
            SizedBox(height: screenHeight * 0.015),

            Text(
              'Enter your mobile number to get started',
              style: fontStyles.commonTextStyle,
            ),
            SizedBox(height: screenHeight * 0.025),

            SizedBox(
              width: screenWidth * 0.9,
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: 'Enter your mobile number',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.03, top: screenHeight * 0.015),
                    child: Text(
                      '+91',
                      style: fontStyles.headingStyle,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.025),
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
            ),

            Spacer(),

            PrimaryButton(
              text: _isLoading ? 'Sending...' : 'Continue',
              icon: SvgPicture.asset('assets/images/Arrow_Circle_Right.svg'),
              onPressed: _isLoading ? null : sendOtp,
            ),
          ],
        ),
      ),
    );
  }
}
