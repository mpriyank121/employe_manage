import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckInService {
  final String _baseUrl = 'https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/checkIn.php';

  /// ✅ Retrieve Employee ID
  Future<String?> _getEmpId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("emp_id");
  }

  /// ✅ Perform Check-In
  Future<bool> performCheckIn() async {
    return await _performAction('checkin');
  }

  /// ✅ Perform Check-Out
  Future<bool> performCheckOut() async {
    return await _performAction('checkout');
  }

  /// ✅ Generic Check-In/Out function
  Future<bool> _performAction(String type) async {
    String? empId = await _getEmpId();
    if (empId == null) {
      print("🔴 Employee ID is missing. Cannot $type.");
      return false;
    }

    try {
      var response = await http.post(
        Uri.parse(_baseUrl),
        body: {
          'emp_id': empId,
          'latitude': '28.5582006',
          'longitude': '77.341035',
          'type': type,
        },
      );

      if (response.statusCode == 200) {
        print("✅ $type Success: ${response.body}");
        return true;
      } else {
        print("🔴 $type Failed: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("🔴 Exception during $type: $e");
      return false;
    }
  }
}
