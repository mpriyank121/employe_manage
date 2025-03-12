import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/NavBar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/primary_button.dart';
import '/Configuration/config_file.dart';
import '/Configuration/style.dart';
import 'package:get/get.dart';
import 'otp_page.dart';
import 'package:employe_manage/API/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLoggedIn ? '/home' : '/login',
      routes: {
        '/login': (context) => MyHomePage(title: 'Login'),
        '/otp': (context) => OtpPage(),
        '/home': (context) => MainScreen(),
      },
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
      /// ✅ Store phone number in SharedPreferences
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

            SizedBox(
              width: screenWidth * 0.9,
              child: TextField(
                controller: _phoneController,
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

            SizedBox(
              width: screenWidth * 0.9,
              height: screenHeight * 0.065,
              child: PrimaryButton(
                initialtext: _isLoading ? 'Sending...' : 'Continue',
                onPressed: _isLoading ? null : sendOtp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
