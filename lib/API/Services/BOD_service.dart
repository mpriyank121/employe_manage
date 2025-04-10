import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiBodService {
  // ✅ Get Employee ID from SharedPreferences
  static Future<String?> getEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('emp_id');
  }

  // ✅ Fetch today's BOD ID from API and store in SharedPreferences
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
        print('bod:$data');

        if (data['found'] == false) {
          print("ℹ️ No BOD found for today.");
          return null;
        }

        if (data.containsKey('bodID') && data['bodID'] != null) {
          String bodId = data['bodID'].toString();
          print("checkhere$bodId");

          // ✅ Save BOD ID in SharedPreferences with consistent key
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('bod_id', bodId); // Consistent key

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
    return prefs.getString('bod_id'); // Consistent key
  }

  // ✅ Send or update BOD data
  static Future<String?> sendData({
    required String taskTitle,
    required String description,
    String? bodId, // If present, updates; else adds new
  }) async {
    try {
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
        'type': bodId != null && bodId.isNotEmpty ? 'updateBOD' : 'addBOD',
        'task_title': taskTitle,
        'description': description,
        if (bodId != null && bodId.isNotEmpty) 'bodID': bodId,
      });

      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print("📡 API Response: $responseBody");

      if (response.statusCode == 200) {
        var data = json.decode(responseBody);

        if (data.containsKey('bodID')) {
          String newBodId = data['bodID'].toString();


          // ✅ Save new or updated bodId
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('bod_id', newBodId);

          return newBodId;
        } else {
          print("⚠️ No bodId found in response");
          return null;
        }
      } else {
        throw Exception("Failed to send BOD: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("🚨 Exception: $e");
      throw Exception("Error while sending BOD: $e");
    }
  }
}
