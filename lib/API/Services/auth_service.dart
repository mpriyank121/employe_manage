import 'package:shared_preferences/shared_preferences.dart';
import '../api_service.dart';
import '../encryption/encryption_helper.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  /// ✅ Encrypts data before sending (except OTP)
  Map<String, String> _encryptData(Map<String, String> data, {bool encryptOtp = true}) {
    return data.map((key, value) {
      if (key == "otp" && !encryptOtp) {
        return MapEntry(key, value);  // ✅ Send OTP as plain text
      }
      return MapEntry(key, EncryptionHelper.encryptString(value));
    });
  }

  /// ✅ Send OTP Function
  Future<bool> sendOtp(String phone) async {
    try {
      var encryptedData = _encryptData({
        'phone': phone,
        'type': 'send_otp',
      });

      var jsonResponse = await _apiClient.postRequest("/login.php", encryptedData);

      if (jsonResponse != null && jsonResponse['status'] == true) {
        print("📌 OTP Sent Successfully");
        return true;
      } else {
        print("❌ Failed to send OTP: ${jsonResponse}");
        return false;
      }
    } catch (e) {
      print("🔴 Exception in sendOtp: $e");
      return false;
    }
  }

  /// ✅ Verify OTP Function (Ensures OTP is NOT Encrypted)
  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      print("📌 Verifying OTP: $otp for Phone: $phone");  // Debugging

      var encryptedData = _encryptData({
        'phone': phone,
        'otp': EncryptionHelper.encryptString(otp),  // ✅ OTP is not encrypted
        'type': ('verify_otp'),
      }, encryptOtp: false);

      var jsonResponse = await _apiClient.postRequest("/login.php", encryptedData);
      print("📨 verifyotp() response: $jsonResponse"); // 🔍 Added debug statement


      if (jsonResponse != null && jsonResponse['status'] == true) {
        print("✅ OTP Verified Successfully");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (jsonResponse.containsKey('emp_id')) {
          await prefs.setString('emp_id', jsonResponse['emp_id']);

        }
        if (jsonResponse.containsKey('super_user')) {
          int superUser = int.parse(jsonResponse['super_user'].toString());
          await prefs.setInt('super_user', superUser); // Save as integer
          print("👑 Super user stored: $superUser");
        }

        return true;
      } else {
        print("❌ Invalid OTP Response: ${jsonResponse}");
        return false;
      }
    } catch (e) {
      print("🔴 Exception in verifyOtp: $e");
      return false;
    }
  }
}
