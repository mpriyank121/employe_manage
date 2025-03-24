import 'dart:convert';
import 'package:http/http.dart' as http;

class AttendanceService {
  static Future<List<Map<String, dynamic>>> fetchAttendanceData() async {
    print("📡 Sending API Request...");

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/attendance_info.php'),
    );

    request.fields.addAll({
      'emp_id': '229',  // Replace with actual empId from SharedPreferences
      'type': 'get_attendanceData',
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print("📜 Raw API Response: $responseBody");

      Map<String, dynamic> jsonData = json.decode(responseBody);
      List<dynamic> attendanceList = jsonData["attendence_Data"] ?? [];

      print("📝 Parsed Attendance List: $attendanceList");

      List<Map<String, dynamic>> formattedData = [];

      for (var record in attendanceList) {
        print("📅 Processing Record: $record");

        if (record is Map<String, dynamic> &&
            record.containsKey('attendence_date') &&
            record.containsKey('attendence_status')) {

          String status = record['attendence_status']?.toString().trim() ?? "N";
          String firstIn = record['first_in']?.toString().trim() ?? record['last_in']?.toString().trim() ?? "N/A";
          String lastOut = record['last_out']?.toString().trim() ?? record['first_out']?.toString().trim() ?? "N/A";

          formattedData.add({
            "date": record['attendence_date'].toString(), // Keeping date as-is
            "status": status,
            "first_in": firstIn,
            "last_out": lastOut,
          });

          print("✅ Stored: ${record['attendence_date']} -> Status: $status, Check-in: $firstIn, Check-out: $lastOut");
        }
      }

      print("📊 Final Attendance Data: $formattedData");
      return formattedData;
    } else {
      print("❌ API Call Failed: ${response.reasonPhrase}");
      return [];
    }
  }
}
