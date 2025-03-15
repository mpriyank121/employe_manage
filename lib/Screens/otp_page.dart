import 'package:employe_manage/Widgets/Resend_Button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:employe_manage/API/api_service.dart';
import '../Configuration/style.dart';
import '../Widgets/otp_text_feild.dart';
import '../Widgets/primary_button.dart';

class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _loadPhoneNumber();
  }

  /// ✅ Load phone number from SharedPreferences
  Future<void> _loadPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phoneNumber = prefs.getString('phone') ?? '';
    });
  }

  /// ✅ Verify OTP and Log in
  Future<void> verifyOtp(String otp) async {
    if (otp.isEmpty || otp.length != 4) {
      Get.snackbar("Error", "Enter a valid 4-digit OTP", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool verified = await _apiService.verifyOtp(phoneNumber, otp);

    setState(() {
      _isLoading = false;
    });

    if (verified) {
      /// ✅ Store login status in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      Get.offAllNamed('/home'); // ✅ Redirect to Home Page
    } else {
      Get.snackbar("Error", "Invalid OTP. Try again.", snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: phoneNumber.isEmpty
          ? Center(child: CircularProgressIndicator()) // ✅ Show loading until phone number loads
          : Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.02),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Enter the verification code sent to',
                    style: fontStyles.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    phoneNumber, // ✅ Dynamically display the phone number
                    style: fontStyles.headingStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    'Enter your OTP to continue',
                    style: fontStyles.subTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: screenHeight * 0.03),

                  /// ✅ OTP Input Field
                  OtpTextField(
                    onOtpComplete: (otp) {
                      verifyOtp(otp);
                    },
                  ),

                  SizedBox(height: screenHeight * 0.03),
                  ResendButton(
                    onResend: () {
                      _apiService.sendOtp(phoneNumber); // ✅ Resend OTP function
                    },
                  ),
                ],
              ),
            ),
          ),

          /// ✅ Verify Button at Bottom
          Positioned(
            bottom: screenHeight * 0.05,
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            child: PrimaryButton(
              text: _isLoading ? 'Verifying...' : 'Verify OTP',
              onPressed: () {
                // Make sure we pass the OTP from OtpTextField to verifyOtp function
                Get.snackbar("Error", "Please enter the OTP", snackPosition: SnackPosition.BOTTOM);
              },
            ),
          ),
        ],
      ),
    );
  }
}
