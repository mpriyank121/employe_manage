import 'package:employe_manage/Configuration/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiEodService {
  // ✅ Function to get Employee ID
  static Future<String?> getEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('emp_id');
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
        Uri.parse('$baseUrl/EOD.php'),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {'emp_id': empId, 'type': 'updateEOD'},
      );

      print("📡 API Response (fetchEodId): ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("🧪 Full Response (fetchEodId): $data");

        if (data['found'] == false) {
          print("ℹ️ No EOD found for today.");
          return null;
        }

        if (data.containsKey('eodId') || data.containsKey('eodID')) {
          String eodId = data['eodId']?.toString() ?? data['eodID'].toString();

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
    String? eodId,
  }) async {
    String? empId = await getEmployeeId();
    if (empId == null || empId.isEmpty) {
      throw Exception("Employee ID not found! Please log in again.");
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/EOD.php'),
    );

    request.fields.addAll({
      'emp_id': empId,
      'type': eodId?.isNotEmpty == true ? 'updateEOD' : 'addEOD',
      'task_title': taskTitle,
      'description': description,
      if (eodId?.isNotEmpty == true) 'eodID': eodId!,
    });

    try {
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print("📡 API Response: $responseBody");

      if (response.statusCode == 200) {
        var data = json.decode(responseBody);
        print("🧪 Full Response (sendEodData): $data");

        if (data['status'] == 'success' || data['message'] == 'EOD updated') {
          print("✅ EOD updated successfully.");
          return eodId ?? "updated";
        }

        if (data.containsKey('eodId') || data.containsKey('eodID')) {
          String newEodId = data['eodId']?.toString() ?? data['eodID'].toString();
          print("✅ EOD ID Received: $newEodId");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('eod_id', newEodId);

          return newEodId;
        }

        throw Exception("Unexpected API response: $data");
      } else {
        print("❌ HTTP Error ${response.statusCode}: ${response.reasonPhrase}");
        throw Exception("Failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("🚨 Exception in sendEodData: $e");
      throw Exception("Unexpected response: $e");
    }
  }

  static Future<bool> isEodSubmitted() async {
    String? empId = await getEmployeeId();

    if (empId == null || empId.isEmpty) {
      throw Exception("Employee ID not found");
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/EOD.php'),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {'emp_id': empId, 'type': 'updateEOD'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("📡 EOD Status Response: $data");
        return data['found'] == true;
      } else {
        throw Exception("Failed to fetch EOD status");
      }
    } catch (e) {
      print("🚨 Error checking EOD status: $e");
      throw Exception("Error checking EOD status: $e");
    }
  }
}
