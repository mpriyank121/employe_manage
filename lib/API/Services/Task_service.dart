import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskService {
  static Future<List<dynamic>> fetchTaskList(String empId, {int limit = 10, int offset = 0}) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/task_list.php'),
      );

      request.fields.addAll({
        'type': 'get_task_data',
        'emp_id': empId, // ✅ Dynamic Employee ID
        'limit': limit.toString(),
        'offset': offset.toString(),
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var data = json.decode(responseBody);

        if (data["message"] == "Success" && data["found"] == true) {
          return data['taskData'] ?? []; // ✅ Correct key
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
