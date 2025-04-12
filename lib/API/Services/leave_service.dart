import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Configuration/app_constants.dart';
import '../encryption/Encryption_helper.dart';
import '../models/leave_model.dart';

class LeaveService {
  static const String apiUrl =
      '$baseUrl//leave_info.php';

  /// Fetches leave data from the API and stores necessary details in SharedPreferences.
  static Future<Map<String, List<LeaveModel>>> fetchLeaveData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? empId = prefs.getString("emp_id");

      if (empId == null) {
        print("🔴 Error: Employee ID not found in SharedPreferences.");
        throw Exception("Employee ID is missing.");
      }

      print("✅ Fetching leave data for Employee ID: $empId");

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields.addAll({
        'emp_id': EncryptionHelper.encryptString(empId),
        'type': EncryptionHelper.encryptString('get_leave_data'),
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print("📡 Raw API Response: $responseBody");

        Map<String, dynamic> jsonResponse = json.decode(responseBody);

        if (jsonResponse['message'] == "Success" &&
            jsonResponse['found'] == true &&
            jsonResponse.containsKey('leave_data')) {

          List<dynamic> leaves = jsonResponse['leave_data'];

          // Categorize leave data
          Map<String, List<LeaveModel>> categorizedData = {
            'Requested': [],
            'Approved': [],
            'Rejected': [],
          };

          // Extract reasons and comments
          List<String> reasons = [];
          List<String> comments = [];

          for (var leave in leaves) {
            LeaveModel leaveModel = LeaveModel.fromJson(leave);

            // Categorize leave data by status
            if (categorizedData.containsKey(leaveModel.status)) {
              categorizedData[leaveModel.status]!.add(leaveModel);
            }

            // Store reason & comment if not empty
            if (leaveModel.resson.isNotEmpty) reasons.add(leaveModel.resson);
            if (leaveModel.comment.isNotEmpty) comments.add(leaveModel.comment);
          }

          // ✅ Store reasons & comments in SharedPreferences
          await prefs.setStringList('leave_reasons', reasons);
          await prefs.setStringList('leave_comments', comments);

          print("✅ Leave data stored in SharedPreferences!");

          return categorizedData;
        } else {
          throw Exception("No leave data found.");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching leave data: $e");
      return {'Error': []};
    }
  }

  /// Retrieves stored leave reasons & comments from SharedPreferences.
  static Future<Map<String, List<String>>> getStoredLeaveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'reasons': prefs.getStringList('leave_reasons') ?? [],
      'comments': prefs.getStringList('leave_comments') ?? [],

    };
  }
}
