import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiBodService {
  // ✅ Function to get Employee ID
  static Future<String?> getEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('emp_id'); // Retrieve emp_id from SharedPreferences
  }

  // ✅ Fetch today's BOD ID
  // ✅ Fetch today's BOD ID and save in SharedPreferences
  static Future<String?> fetchBodId() async {
    String? empId = await getEmployeeId();

    if (empId == null || empId.isEmpty) {
      print("❌ Error: Employee ID not found!");
      throw Exception("Employee ID not found! Please log in again.");
    }

    try {
      final response = await http.post(
        Uri.parse('https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/BOD.php'),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {'emp_id': empId, 'type': 'updateBOD'},
      );

      print("📡 API Response (fetchBodId): ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['found'] == false) {
          print("ℹ️ No BOD found for today.");
          return null;
        }

        if (data.containsKey('bodId') && data['bodId'] != null) {
          String bodId = data['bodId'].toString();

          // ✅ Save BOD ID in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('bod_id', bodId);

          print("✅ Saved BOD ID in SharedPreferences: $bodId");
          return bodId;
        }
      }
      return null;
    } catch (e) {
      print("🚨 Exception: $e");
      throw Exception("Error fetching BOD: $e");
    }
  }

// ✅ Retrieve BOD ID from SharedPreferences
  static Future<String?> getBodIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('bod_id');
  }

  // ✅ Function to send or update BOD data
  static Future<String?> sendData({
    required String taskTitle,
    required String description,
    String? bodId, // ✅ Correct parameter declaration
  }) async {
    String? empId = await getEmployeeId();
    if (empId == null || empId.isEmpty) {
      throw Exception("Employee ID not found! Please log in again.");
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/BOD.php'),
    );

    request.fields.addAll({
      'emp_id': empId,
      'type': bodId?.isNotEmpty == true ? 'updateBOD' : 'addBOD', // ✅ Fixed condition
      'task_title': taskTitle,
      'description': description,
      if (bodId?.isNotEmpty == true) 'bodID': bodId!, // ✅ Added proper null check
    });

    try {
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print("📡 API Response: $responseBody");

      if (response.statusCode == 200) {
        var data = json.decode(responseBody);

        if (data.containsKey('bodId')) {
          String newBodId = data['bodId'].toString();
          print("✅ BOD ID Received: $newBodId");

          // ✅ Save new BOD ID in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('bod_id', newBodId);

          return newBodId; // ✅ Corrected return statement
        } else {
          print("⚠️ Warning: No BOD ID in response.");
          throw Exception("No BOD ID returned from API.");
        }
      } else {
        throw Exception("Failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("🚨 Exception in sendData: $e");
      throw Exception("Unexpected response: $e");
    }
  }

}
