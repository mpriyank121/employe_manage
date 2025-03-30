import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiEodService {
  // ✅ Function to get Employee ID
  static Future<String?> getEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('emp_id'); // Retrieve emp_id from SharedPreferences
  }

  // ✅ Fetch today's EOD ID and save in SharedPreferences
  static Future<String?> fetchEodId() async {
    String? empId = await getEmployeeId();

    if (empId == null || empId.isEmpty) {
      print("❌ Error: Employee ID not found!");
      throw Exception("Employee ID not found! Please log in again.");
    }

    try {
      final response = await http.post(
        Uri.parse('https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/EOD.php'),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {'emp_id': empId, 'type': 'updateEOD'},
      );

      print("📡 API Response (fetchEodId): ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['found'] == false) {
          print("ℹ️ No EOD found for today.");
          return null;
        }

        if (data.containsKey('eodId') && data['eodId'] != null) {
          String eodId = data['eodId'].toString();

          // ✅ Save EOD ID in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('eod_id', eodId);

          print("✅ Saved EOD ID in SharedPreferences: $eodId");
          return eodId;
        }
      }
      return null;
    } catch (e) {
      print("🚨 Exception: $e");
      throw Exception("Error fetching EOD: $e");
    }
  }

  // ✅ Retrieve EOD ID from SharedPreferences
  static Future<String?> getEodIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('eod_id');
  }

  // ✅ Function to send or update EOD data
  static Future<String?> sendEodData({
    required String taskTitle,
    required String description,
    String? eodId, // ✅ Correct parameter declaration
  }) async {
    String? empId = await getEmployeeId();
    if (empId == null || empId.isEmpty) {
      throw Exception("Employee ID not found! Please log in again.");
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/EOD.php'),
    );

    request.fields.addAll({
      'emp_id': empId,
      'type': eodId?.isNotEmpty == true ? 'updateEOD' : 'addEOD', // ✅ Fixed condition
      'task_title': taskTitle,
      'description': description,
      if (eodId?.isNotEmpty == true) 'eodID': eodId!, // ✅ Added proper null check
    });

    try {
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print("📡 API Response: $responseBody");

      if (response.statusCode == 200) {
        var data = json.decode(responseBody);

        if (data.containsKey('eodId')) {
          String newEodId = data['eodId'].toString();
          print("✅ EOD ID Received: $newEodId");

          // ✅ Save new EOD ID in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('eod_id', newEodId);

          return newEodId; // ✅ Corrected return statement
        } else {
          print("⚠️ Warning: No EOD ID in response.");
          throw Exception("No EOD ID returned from API.");
        }
      } else {
        throw Exception("Failed: \${response.reasonPhrase}");
      }
    } catch (e) {
      print("🚨 Exception in sendEodData: $e");
      throw Exception("Unexpected response: $e");
    }
  }
}
