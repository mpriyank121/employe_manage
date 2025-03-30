import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Screens/otp_page.dart';
import '../Services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;

  /// ✅ Send OTP
  Future<void> sendOtp(String phone) async {
    if (phone.isEmpty || phone.length != 10) {
      Get.snackbar("Error", "Enter a valid 10-digit phone number", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    bool otpSent = await _authService.sendOtp(phone);
    isLoading.value = false;

    if (otpSent) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('phone', phone);
      Get.to(() => OtpPage(phone: phone));
    } else {
      Get.snackbar("Error", "Failed to send OTP. Try again.", snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// ✅ Verify OTP
  Future<void> verifyOtp(String phone, String otp) async {
    if (otp.isEmpty || otp.length != 4) {
      Get.snackbar("Error", "Enter a valid 4-digit OTP", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    bool verified = await _authService.verifyOtp(phone, otp);
    isLoading.value = false;

    if (verified) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Get.offAllNamed('/home');
    } else {
      Get.snackbar("Error", "Invalid OTP. Try again.", snackPosition: SnackPosition.BOTTOM);
      print("❌ Invalid OTP entered: $otp");
    }
  }
}
