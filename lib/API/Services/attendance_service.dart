import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceService {
  static Future<List<Map<String, dynamic>>> fetchAttendanceData(int? year, int? month) async {
    print("📡 Sending API Request...");
    final prefs = await SharedPreferences.getInstance();
    final empId = prefs.getString('emp_id') ?? '';

    // Calculate the first and last day of the selected month
    final DateTime firstDayOfMonth = DateTime(year!, month!, 1);
    final DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

    final String startDate = firstDayOfMonth.toIso8601String().split('T')[0]; // 'yyyy-MM-dd'
    final String endDate = lastDayOfMonth.toIso8601String().split('T')[0];

    print("📆 Fetching data from $startDate to $endDate");

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/attendance_info.php'),
    );

    request.fields.addAll({
      'emp_id': empId,
      'type': 'get_attendanceData',
      'start_date': startDate,
      'end_date': endDate,
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print("📜 Raw API Response: $responseBody");

      Map<String, dynamic> jsonData = json.decode(responseBody);
      List<dynamic> attendanceList = jsonData["attendence_Data"] ?? [];

      /// ✅ Update counts from "Countdata'"'
      ///
      var countData = null;
      if (jsonData.containsKey("Countdata") && jsonData["Countdata"].isNotEmpty) {
        var count = jsonData["Countdata"][0];
        countData = jsonData["Countdata"][0];
        print("✅ Counts -> P: ${count['present_count']}, A: ${count['absent_count']}, L: ${count['halfday_count']}, W: ${count['week_off_count']}");
        // you can update controller values from here if needed
      }

      List<Map<String, dynamic>> formattedData = [];

      for (var record in attendanceList) {
        if (record is Map<String, dynamic>) {
          String status = record['attendence_status']?.toString().trim() ?? "N";
          String firstIn = record['first_in']?.toString().trim() ?? record['last_in']?.toString().trim() ?? "N/A";
          String lastOut = record['last_out']?.toString().trim() ?? record['first_out']?.toString().trim() ?? "N/A";
          String checkInImage = record['checkinImage']?.toString()?.trim() ?? "";
          String checkOutImage = record['checkoutImage']?.toString()?.trim() ?? "";

          formattedData.add({
            "date": record['attendence_date'].toString(),
            "status": status,
            "first_in": firstIn,
            "last_out": lastOut,
            "checkinImage": checkInImage,
            "checkoutImage": checkOutImage,
          });
        }
      }

      return formattedData;
    } else {
      print("❌ API Call Failed: ${response.reasonPhrase}");
      return [];
    }
  }

  static Future<Map<String, dynamic>> fetchAttendanceDataByMonth(int? year, int? month) async {
    print("📡 Sending API Request...");
    final prefs = await SharedPreferences.getInstance();
    final empId = prefs.getString('emp_id') ?? '';

    // Calculate the first and last day of the selected month
    final DateTime firstDayOfMonth = DateTime(year!, month!, 1);
    final DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

    final String startDate = firstDayOfMonth.toIso8601String().split('T')[0]; // 'yyyy-MM-dd'
    final String endDate = lastDayOfMonth.toIso8601String().split('T')[0];

    print("📆 Fetching data from $startDate to $endDate");

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/attendance_info.php'),
    );

    request.fields.addAll({
      'emp_id': empId,
      'type': 'get_attendanceData',
      'start_date': startDate,
      'end_date': endDate,
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      print("📜 Raw API Response: $responseBody");

      Map<String, dynamic> jsonData = json.decode(responseBody);
      List<dynamic> attendanceList = jsonData["attendence_Data"] ?? [];

      /// ✅ Update counts from "Countdata'"'
      ///
      var countData = null;
      if (jsonData.containsKey("Countdata") && jsonData["Countdata"].isNotEmpty) {
        var count = jsonData["Countdata"][0];
        countData = jsonData["Countdata"][0];
        print("✅ Counts -> P: ${count['present_count']}, A: ${count['absent_count']}, L: ${count['halfday_count']}, W: ${count['week_off_count']}");
        // you can update controller values from here if needed
      }

      List<Map<String, dynamic>> formattedData = [];

      for (var record in attendanceList) {
        if (record is Map<String, dynamic>) {
          String status = record['attendence_status']?.toString().trim() ?? "N";
          String firstIn = record['first_in']?.toString().trim() ?? record['last_in']?.toString().trim() ?? "N/A";
          String lastOut = record['last_out']?.toString().trim() ?? record['first_out']?.toString().trim() ?? "N/A";
          String checkInImage = record['checkinImage']?.toString()?.trim() ?? "";
          String checkOutImage = record['checkoutImage']?.toString()?.trim() ?? "";

          formattedData.add({
            "date": record['attendence_date'].toString(),
            "status": status,
            "first_in": firstIn,
            "last_out": lastOut,
            "checkinImage": checkInImage,
            "checkoutImage": checkOutImage,
          });
        }
      }

      return {'formattedData':formattedData,'countData':countData};
    } else {
      print("❌ API Call Failed: ${response.reasonPhrase}");
      return {};
    }
  }

}
