import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckStatus {
  final String _baseUrl = 'https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/attendance_info.php';

  /// Fetch Check-In and Check-Out Status from API
  Future<Map<String, dynamic>?> getCheckInStatus(String empId) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));
      request.fields.addAll({
        'type': 'emp_today_attendance',
        'emp_id': empId,
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
