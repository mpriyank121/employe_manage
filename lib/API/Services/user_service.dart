import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Configuration/app_constants.dart';
import 'package:employe_manage/API/models/holiday_model.dart';
import '../encryption/Encryption_helper.dart';
import '../models/attendence_model.dart'; // ✅ Use one consistent import path everywhere

class UserService {
  /// ✅ Fetch Employee Data
  Future<Map<String, dynamic>?> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString('phone');

    if (phone == null) {
      print("🔴 Phone number not found in SharedPreferences");
      return null;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/emp_info.php'),
      );

      request.fields.addAll({
        'phone': EncryptionHelper.encryptString(phone),
        'type': EncryptionHelper.encryptString('user_info'),
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);
        return jsonResponse['status'] == true ? jsonResponse['data'] : null;
      } else {
        print("🔴 Server Error: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("🔴 Exception in fetchUserData: $e");
      return null;
    }
  }

  /// ✅ Fetch Holidays
  Future<List<Holiday>> fetchHolidays(String phone) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis//emp_info.php"),
      );

      request.fields.addAll({
        'phone': EncryptionHelper.encryptString(phone),
        'type': EncryptionHelper.encryptString('user_info'),
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var jsonData = json.decode(responseBody);

        // ✅ Print full response for debugging
        print("📜 Full API Response: $jsonData");

        // ✅ Check if jsonData contains the expected holiday list
        if (jsonData is Map && jsonData.containsKey('hoidayList')) {
          var holidaysData = jsonData['hoidayList'];

          // ✅ Ensure 'data' is a list
          if (holidaysData is List) {
            List<Holiday> holidays = holidaysData
                .map((item) => Holiday.fromJson(item))
                .toList();

            // ✅ Debugging: Print holidays
            for (var holiday in holidays) {
              print("📅 Holiday: ${holiday.holiday_date}, Reason: ${holiday.holiday}");
            }

            return holidays;
          } else {
            print("🔴 'data' is not a list. Found: ${holidaysData.runtimeType}");
          }
        } else {
          print("⚠️ No 'data' key found in response or invalid format.");
        }

        return [];
      } else {
        print("🔴 Server Error: ${response.reasonPhrase}");
        throw Exception('Failed to load holidays: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("🔴 Exception in fetchHolidays: $e");
      return [];
    }
  }
  Future<AttendanceData?> fetchAttendanceData({required String startDate, required String endDate}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? phone = prefs.getString('phone');

      var response = await http.post(
        Uri.parse("https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis//emp_info.php"),
        body: {
          'phone': EncryptionHelper.encryptString(phone!),
          'type': EncryptionHelper.encryptString('user_info'),
        },
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData['status'] == true && jsonData.containsKey('attendanceData')) {
          return AttendanceData.fromJson(jsonData['attendanceData']);
        } else {
          print("⚠️ Attendance data not found in API response.");
        }
      } else {
        print("❌ Server Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("❌ Exception in fetchAttendanceData: $e");
    }
    return null;
  }





}
