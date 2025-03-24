import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

class CheckInService {
  final String _baseUrl = 'https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/checkIn.php';
  final String _uploadUrl = 'https://your-server.com/upload_image.php'; // Change this to your actual upload API

  /// ✅ Save Employee ID
  Future<void> saveEmpId(String empId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("emp_id", empId);
  }
  /// ✅ Retrieve Employee ID
  Future<String?> _getEmpId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("emp_id");
  }

  /// ✅ Perform Check-In with Image Upload
  Future<bool> performCheckIn(File imageFile) async {
    return await uploadImageAndPerformAction(imageFile, 'checkin');
  }

  /// ✅ Perform Check-Out with Image Upload
  Future<bool> performCheckOut(File imageFile) async {
    return await uploadImageAndPerformAction(imageFile, 'checkout');
  }

  /// ✅ Upload Image and Check-In/Check-Out
  Future<bool> uploadImageAndPerformAction(File imageFile, String type) async {
    String? empId = await _getEmpId();
    if (empId == null) {
      print("🔴 Employee ID is missing. Cannot $type.");
      return false;
    }

    try {
      // ✅ Create Multipart Request
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

      // ✅ Attach Form Data
      request.fields['emp_id'] = empId;
      request.fields['latitude'] = '28.5582006';
      request.fields['longitude'] = '77.341035';
      request.fields['type'] = type;

      // ✅ Attach Image File
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // Field name expected by API
          imageFile.path,
          filename: basename(imageFile.path),
        ),
      );

      // ✅ Send Request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print("✅ $type Success: $responseBody");
        return true;
      } else {
        print("🔴 $type Failed: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("🔴 Exception during $type: $e");
      return false;
    }
  }
}
