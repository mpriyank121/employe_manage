import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Configuration/config_file.dart';

class UserService {
  /// ✅ Fetch Employee Data
  Future<Map<String, dynamic>?> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString('phone');

    if (phone == null) {
      print("🔴 Phone number not found in SharedPreferences");
      return null;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/emp_info.php'), // Use base URL from config
      );

      request.fields.addAll({
        'phone': phone,
        'type': 'user_info',
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);
        if (jsonResponse['status'] == true) {
          return jsonResponse['data']; // ✅ Return only user data
        } else {
          print("🔴 API Error: ${jsonResponse['message']}");
          return null;
        }
      } else {
        print("🔴 Server Error: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("🔴 Exception in fetchUserData: $e");
      return null;
    }
  }
}
///
