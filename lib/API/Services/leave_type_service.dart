import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LeaveTypeService {
  static const String apiUrl =
      'https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis//leave_info.php';

  /// Fetches available leave types dynamically
  static Future<List<Map<String, String>>> fetchLeaveTypes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? empId = prefs.getString("emp_id");

    if (empId == null) {
      print("🔴 Error: Employee ID not found in SharedPreferences.");
      throw Exception("Employee ID is missing.");
    }

    print("✅ Fetching leave types for Employee ID: $empId");

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields.addAll({
      'emp_id': empId,
      'type': 'get_leave_type',
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print("📡 Leave Type API Response: $responseBody");

      Map<String, dynamic> jsonResponse = json.decode(responseBody);

      if (jsonResponse['message'] == "Success" && jsonResponse.containsKey('leave_type')) {
        List<dynamic> leaveTypeList = jsonResponse['leave_type'];

        return leaveTypeList.map((type) {
          return {
            "id": type['id'].toString(),
            "name": type['leave_name'].toString(),
          };
        }).toList();
      }
    }
    throw Exception("Failed to load leave types");
  }

  /// Applies for leave
  static Future<bool> applyLeave({
    required String leaveId,
    required String startDate,
    required String endDate,
    required String note,
    required String type,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? empId = prefs.getString("emp_id");

    if (empId == null) {
      print("🔴 Error: Employee ID not found in SharedPreferences.");
      throw Exception("Employee ID is missing.");
    }

    print("✅ Applying leave for Employee ID: $empId");
    print("🟡 Request Payload: emp_id=$empId, type=$type, leave_id=$leaveId, from_date=$startDate, to_date=$endDate, note=$note");


    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields.addAll({
      'emp_id': "$empId",
      'type': type,  // ✅ Action type
      'leave_type': leaveId,    // ✅ Matching API response key "id"
      'start_date': startDate,
      'end_date': endDate,
      'note': note,
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print("📡 Apply Leave API Response: $responseBody");

      Map<String, dynamic> jsonResponse = json.decode(responseBody);

      if (jsonResponse["status"] == true) {
        print("✅ Leave applied successfully.");
        return true;

      }
      else {
        print("❌ Error from API: ${jsonResponse['message']}");
      }
    }
    return false;
  }
}
