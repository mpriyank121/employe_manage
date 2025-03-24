import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/leave_model.dart';

class LeaveService {
  static const String apiUrl =
      'https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis//leave_info.php';

  static Future<Map<String, List<LeaveModel>>> fetchLeaveData(String empId) async {

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? empId = prefs.getString("emp_id");

    if (empId == null) {
      print("🔴 Error: Employee ID not found in SharedPreferences.");
      throw Exception("Employee ID is missing.");
    }

    print("✅ Fetching leave data for Employee ID: $empId");

    request.fields.addAll({
      'emp_id': empId,
      'type': 'get_leave_data',
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print("📡 Raw API Response: $responseBody"); // ✅ Print API response

      Map<String, dynamic> jsonResponse = json.decode(responseBody);

      if (jsonResponse['message'] == "Success" && jsonResponse['found']) {
        List<dynamic> leaves = jsonResponse['leave_data'];
        print("📝 Parsed Leave Data: $leaves");


        // Categorize data into different statuses
        Map<String, List<LeaveModel>> categorizedData = {
          'Approved': [],
          'Requested': [],
          'Rejected': [],
        };

        for (var leave in leaves) {
          LeaveModel leaveModel = LeaveModel.fromJson(leave);
          if (categorizedData.containsKey(leaveModel.status)) {
            categorizedData[leaveModel.status]!.add(leaveModel);
          }
        }

        return categorizedData;
      }
    }
    throw Exception("Failed to load leave data");
  }
}
