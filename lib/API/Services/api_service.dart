import 'package:shared_preferences/shared_preferences.dart';
import '../api_client.dart';
import '../Encryption_helper.dart';

class ApiService {
  final ApiClient _apiClient = ApiClient();

  /// ✅ Helper to encrypt data before sending to API
  Map<String, String> _encryptData(Map<String, String> data) {
    return data.map((key, value) => MapEntry(key, EncryptionHelper.encryptString(value)));
  }

  /// ✅ Send OTP Function
  Future<bool> sendOtp(String phone) async {
    try {
      var encryptedData = _encryptData({
        'phone': phone,
        'type': 'send_otp',
      });

      var jsonResponse = await _apiClient.postRequest("/login.php", encryptedData);
      print('Sended from here');
      return jsonResponse != null && jsonResponse['status'] == true;

    } catch (e) {
      print("🔴 Exception in sendOtp: $e");
      return false;
    }
  }

  /// ✅ Verify OTP Function
  Future<bool> verifyOtp(String phone, String otp) async {
    try {
      var encryptedData = _encryptData({
        'phone': phone,
        'otp': otp,
        'type': 'verify_otp',
      });

      var jsonResponse = await _apiClient.postRequest("/login.php", encryptedData);

      if (jsonResponse != null && jsonResponse['status'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (jsonResponse.containsKey('emp_id')) {
          await prefs.setString('emp_id', jsonResponse['emp_id']);
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("🔴 Exception in verifyOtp: $e");
      return false;
    }
  }
}
