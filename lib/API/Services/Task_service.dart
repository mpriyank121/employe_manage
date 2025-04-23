import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../Configuration/app_constants.dart';
import '../encryption/Encryption_helper.dart'; // For Date Formatting


class TaskService {
  static Future<List<dynamic>> fetchTaskList(String empId, {int limit = 10, int offset = 1,
    DateTime? startDate,
    DateTime? endDate,}) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/task_list.php'),
      );

      // ✅ Ensuring date format before sending
      String formattedStartDate = startDate != null ? DateFormat('yyyy-MM-dd').format(startDate) : '';
      String formattedEndDate = endDate != null ? DateFormat('yyyy-MM-dd').format(endDate) : '';

      debugPrint("Request is limit $limit");
      debugPrint("Request is page$offset");

      request.fields.addAll({
        'type': EncryptionHelper.encryptString('get_task_data'),
        'emp_id': EncryptionHelper.encryptString(empId), // ✅ Dynamic Employee ID
        'limit': (limit.toString()),
        'page': (offset.toString()),

        if (formattedStartDate.isNotEmpty) 'start_date': EncryptionHelper.encryptString(formattedStartDate),
        if (formattedEndDate.isNotEmpty) 'end_date': EncryptionHelper.encryptString(formattedEndDate),

      });
      

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var data = json.decode(responseBody);
                print("taskdata whic is $data");


        if (data["message"] == "Success" && data["found"] == true) {
          return data['taskData'] ?? [];

          // ✅ Correct key
        } else {
          print("⚠️ No tasks found.");
          return [];
        }
      } else {
        throw Exception("❌ API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 Error fetching tasks: $e");
      throw Exception("❌ Failed to fetch tasks.");
    }
  }
}
