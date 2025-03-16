import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/otp_page.dart';
import '../Services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;

  /// ✅ Send OTP Function
  Future<void> sendOtp(String phoneNumber) async {
    if (phoneNumber.isEmpty || phoneNumber.length != 10) {
      Get.snackbar("Error", "Enter a valid 10-digit phone number", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    bool otpSent = await _authService.sendOtp(phoneNumber);
    isLoading.value = false;

    if (otpSent) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone', phoneNumber);
      print("📌 Phone number saved: $phoneNumber");

      Get.to(() => OtpPage(phone: phoneNumber));
    } else {
      print('🔴 Error in sending OTP');
      Get.snackbar("Error", "Failed to send OTP. Try again.", snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// ✅ Verify OTP Function
  Future<void> verifyOtp(String phone, String otp) async {
    isLoading.value = true;
    bool verified = await _authService.verifyOtp(phone, otp);
    isLoading.value = false;

    if (verified) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Get.offAllNamed('/home');
    } else {
      Get.snackbar("Error", "Invalid OTP. Try again.", snackPosition: SnackPosition.BOTTOM);
    }
  }
}
