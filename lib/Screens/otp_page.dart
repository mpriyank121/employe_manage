import 'package:employe_manage/Screens/welcom_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API/api_service.dart';
import '../Widgets/primary_button.dart';
import '/Configuration/config_file.dart';
import 'package:employe_manage/Configuration/style.dart';

class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  late String phone;

  @override
  void initState() {
    super.initState();
    phone = Get.arguments['phone'] ?? ''; // ✅ Get phone number dynamically
    print("🔹 Received Phone: $phone"); // Debugging

  }
  /// ✅ Verify OTP Function
  void verifyOtp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userPhone', phone); // Save phone number if needed

    Get.snackbar('Success', 'OTP Verified!',
        snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
    String otp = _otpController.text.trim();
    print("🔹 Entered OTP: $otp"); // ✅ Debugging

    if (otp.length < 4) {
      print('OTP is too short');
      Get.snackbar('Error', 'Enter a valid OTP',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      return;
    }

    // ✅ Encrypt OTP and phone number
    String encryptedOtp = _apiService.encryptString(otp);
    String encryptedPhone = _apiService.encryptString(phone);

    print("🔹 Encrypted OTP: $encryptedOtp"); // ✅ Debugging
    print("🔹 Encrypted Phone: $encryptedPhone"); // ✅ Debugging

    setState(() => _isLoading = true); // ✅ Set loading before API call

    try {
      bool success = await _apiService.verifyOtp(encryptedPhone, encryptedOtp); // ✅ Send encrypted data

      setState(() => _isLoading = false); // ✅ Stop loading after response

      print('Success is $success');

      if (success) {
        print('✅ OTP is verified');
        Get.snackbar('Success', 'OTP Verified!',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green);
        Get.offAll(() => welcomepage(title: 'Welcome',)); // ✅ Navigate to Welcome Page
      } else {
        print('❌ OTP is incorrect');
        Get.snackbar('Error', 'Invalid OTP',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      }
    } catch (e) {
      setState(() => _isLoading = false); // ✅ Ensure loading stops even if API fails
      print("❌ API Error: $e");
      Get.snackbar('Error', 'Something went wrong. Try again.',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
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
      body: Stack(
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
                    phone, // ✅ Dynamically display the phone number
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
                  SizedBox(
                    width: screenWidth * 0.8,
                    child: TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),
                  PrimaryButton(
                    initialtext: 'Resend Code',
                    onPressed: () {
                      _apiService.sendOtp(phone); // ✅ Resend OTP function
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
              initialtext: _isLoading ? 'Verifying...' : 'Verify OTP',
              onPressed: verifyOtp,
            ),
          ),
        ],
      ),
    );
  }
}
