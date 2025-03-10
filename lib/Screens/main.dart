import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:flutter/material.dart';
import '../Widgets/primary_button.dart';
import '/Configuration/config_file.dart';
import '/Configuration/style.dart';
import 'package:get/get.dart';
import 'otp_page.dart';
import 'package:employe_manage/API/api_service.dart';
import 'package:employe_manage/Configuration/routes.dart';
import 'package:employe_manage/Configuration/getpages.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _phoneController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  /// ✅ Send OTP Function
  void sendOtp() async {
    String phone = _phoneController.text.trim();

    if (phone.length < 10) {
      Get.snackbar('Error', 'Enter a valid phone number',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
      return;
    }
    print('is entered');
    String encryptedPhone = _apiService.encryptString(phone); // ✅ Encrypt phone number
print('is everything ok');
    bool success = await _apiService.sendOtp(encryptedPhone);

    print("🔹 Encrypted Phone: $encryptedPhone"); // Debugging
    if (success) {
      print('✅ OTP Sent Successfully');
      if (encryptedPhone != null && encryptedPhone.isNotEmpty) {
        Get.to(() => OtpPage(), arguments: {'phone': phone});
      } else {
        print("❌ Error: Encrypted phone is null or empty!");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Bookchor',
        leading: AppBarConfig.getIconImage(imagePath: 'assets/images/bc 3.svg'),
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

            // ✅ Corrected TextField
            SizedBox(
              width: screenWidth * 0.9,
              child: TextField(
                controller: _phoneController, // ✅ Linked controller
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: 'Enter your mobile number',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.03, top: screenHeight * 0.01),
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

            // ✅ Button with loading state
            SizedBox(
              width: screenWidth * 0.9,
              height: screenHeight * 0.065,
              child: PrimaryButton(
                initialtext: _isLoading ? 'Sending...' : 'Continue',
                onPressed: _isLoading ? null : sendOtp, // Disable button while loading
              ),
            ),
          ],
        ),
      ),
    );
  }
}
