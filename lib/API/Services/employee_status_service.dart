import 'dart:convert';
import 'package:employe_manage/API/encryption/Encryption_helper.dart';
import 'package:http/http.dart' as http;

import '../../Configuration/app_constants.dart';

class CheckStatus {
  final String _baseUrl = '$baseUrl/attendance_info.php';

  /// Fetch Check-In and Check-Out Status from API
  Future<Map<String, dynamic>?> getCheckInStatus(String empId) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
      request.fields.addAll({
        'type': EncryptionHelper.encryptString('emp_today_attendance'),
        'emp_id': EncryptionHelper.encryptString(empId),
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> jsonResponse = json.decode(responseBody);

        if (jsonResponse['status'] == 'success') {
          return {
            'firstIn': jsonResponse['first_in'] ?? null,
            'lastOut': jsonResponse['last_out'] ?? null,
            'isCheckedIn': jsonResponse['is_checked_in'] ?? false,
          };
        }
      } else {
        print("Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Exception in getCheckInStatus: $e");
    }
    return null;
  }
}
