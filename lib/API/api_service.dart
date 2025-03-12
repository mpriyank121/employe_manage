import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Encryption_helper.dart';
import 'api_client.dart';
import '../Screens/otp_page.dart';

class ApiService {
  final ApiClient _apiClient = ApiClient(); // ✅ Create an instance of ApiClient

  /// ✅ Send OTP Function
  Future<bool> sendOtp(String phone) async {
    try {
      String encryptedPhone = EncryptionHelper.encryptString(phone);
      String encryptedType = EncryptionHelper.encryptString('send_otp');

      var jsonResponse = await _apiClient.postRequest("login.php", {
        'phone': encryptedPhone,
        'type': encryptedType,
      });

      if (jsonResponse != null && jsonResponse['status'] == true) {
        print("✅ OTP Sent Successfully");

        /// ✅ Store phone number in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('phone', phone);

        /// ✅ Navigate to OTP Page
        Get.to(() => OtpPage());

        return true;
      } else {
        print("🔴 OTP Sending Failed");
        return false;
      }
    } catch (e) {
      print("🔴 Exception in sendOtp: $e");
      return false;
    }
  }

  /// ✅ Verify OTP Function
  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      String encryptedPhone = EncryptionHelper.encryptString(phone);
      String encryptedOtp = EncryptionHelper.encryptString(otp);
      String encryptedType = EncryptionHelper.encryptString('verify_otp');

      var jsonResponse = await _apiClient.postRequest("login.php", {
        'phone': encryptedPhone,
        'otp': encryptedOtp,
        'type': encryptedType,
      });

      if (jsonResponse != null && jsonResponse['status'] == true) {
        print("✅ OTP Verified Successfully");

        /// ✅ Save login status in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        /// ✅ Navigate to Home
        Get.offAllNamed('/home');

        return true;
      } else {
        print("🔴 OTP Verification Failed");
        return false;
      }
    } catch (e) {
      print("🔴 Exception in verifyOtp: $e");
      return false;
    }
  }
}

