import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckInService {
  final String _baseUrl = 'https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/checkIn.php';

  /// ✅ Retrieve Employee ID from SharedPreferences
  Future<String?> _getEmpId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("emp_id");
  }

  /// ✅ Perform Check-In
  Future<bool> performCheckIn() async {
    String? empId = await _getEmpId();
    if (empId == null) {
      print("🔴 Employee ID is missing. Cannot check-in.");
      return false;
    }

    try {
      var response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'emp_id': empId,
          'latitude': '28.5582006',
          'longitude': '77.341035',
          'type': 'checkin',
        },
      );

      if (response.statusCode == 200) {
        print("✅ Check-In Success: ${response.body}");
        return true;
      } else {
        print("🔴 Check-In Failed: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("🔴 Exception during check-in: $e");
      return false;
    }
  }

  /// ✅ Perform Check-Out
  Future<bool> performCheckOut() async {
    String? empId = await _getEmpId();
    if (empId == null) {
      print("🔴 Employee ID is missing. Cannot check-out.");
      return false;
    }

    try {
      var response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'emp_id': empId,
          'latitude': '28.5582006',
          'longitude': '77.341035',
          'type': 'checkout',
        },
      );

      if (response.statusCode == 200) {
        print("✅ Check-Out Success: ${response.body}");
        return true;
      } else {
        print("🔴 Check-Out Failed: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("🔴 Exception during check-out: $e");
      return false;
    }
  }
}
