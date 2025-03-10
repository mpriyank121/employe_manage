import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class ApiService {
  final String baseUrl = "https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis//login.php";

  /// ✅ Encryption Function
  String encryptString(String input) {
    try {
      int inputLen = input.length;
      int randKey = Random().nextInt(9) + 1; // Generate random key (1-9)
      List<int> inputChr = List<int>.filled(inputLen, 0);

      for (int i = 0; i < inputLen; i++) {
        inputChr[i] = input.codeUnitAt(i) - randKey; // Shift ASCII values
      }

      StringBuffer sb = StringBuffer();
      for (int i in inputChr) {
        sb.write('$i  a'); // Append ASCII values with " a" separator
      }

      sb.write((randKey.toString().codeUnitAt(0)) + 50); // Append encryption key
      return sb.toString();
    } catch (e) {
      return "";
    }
  }

  /// ✅ Send OTP Function (with Encryption)
  Future<bool> sendOtp(String phone) async {
    String encryptedPhone = (phone); // Encrypt phone number

    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.fields.addAll({
      'phone': encryptedPhone,
      'type': encryptString('send_otp'),
    });

    var response = await request.send();
    String responseData = await response.stream.bytesToString();

    print("🔹 Encrypted Phone: $encryptedPhone");
    print("🔹 API Response: $responseData"); // Debugging

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseData);
      return jsonResponse['status'] == true; // Adjust based on API response
    } else {
      return false;
    }
  }

  /// ✅ Verify OTP Function (with Encryption)
  Future<bool> verifyOtp(String phone, String otp) async {
    String encryptedPhone = (phone);
    String encryptedOtp = (otp); // Encrypt OTP

    var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.fields.addAll({
      'phone': encryptedPhone,
      'otp': encryptedOtp,
      'type': encryptString('verify_otp'),
    });

    var response = await request.send();
    String responseData = await response.stream.bytesToString();

    print("🔹 Encrypted Phone: $encryptedPhone");
    print("🔹 Encrypted OTP: $encryptedOtp");
    print("🔹 API Response: $responseData"); // Debugging

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseData);
      return jsonResponse['status'] == true; // Ensure API response validation
    } else {
      return false;
    }
  }
}
