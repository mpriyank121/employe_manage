import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class CheckInService {
  final String _baseUrl = 'https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/checkIn.php';

  /// Save Employee ID
  Future<void> saveEmpId(String empId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("emp_id", empId);
  }

  /// Retrieve Employee ID
  Future<String?> _getEmpId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("emp_id");
  }

  /// Get File Extension
  String getFileExtension(String filePath) {
    return extension(filePath);
  }

  /// Get MIME Type
  String? getMimeType(String filePath) {
    return lookupMimeType(filePath);
  }

  /// Get Current Location
  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("🔴 Location services are disabled.");
        showLocationErrorDialog();
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("🔴 Location permissions are denied.");
          showLocationErrorDialog();
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("🔴 Location permissions are permanently denied.");
        showLocationErrorDialog();
        return null;
      }

      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      print("🔴 Error getting location: $e");
      return null;
    }
  }

  /// Perform Check-In with Image Upload
  Future<bool> performCheckIn(File imageFile) async {
    return await uploadImageAndPerformAction(imageFile, 'checkin', 'checkIn_image') == null;
  }

  /// Perform Check-Out with Image Upload
  Future<bool> performCheckOut(File imageFile) async {
    return await uploadImageAndPerformAction(imageFile, 'checkout', 'checkOut_image') == null;
  }

  /// Upload Image and Perform Check-In/Check-Out
  Future<String?> uploadImageAndPerformAction(File imageFile, String type, String imageKey) async {
    String? empId = await _getEmpId();
    if (empId == null) {
      print("🔴 Employee ID is missing. Cannot $type.");
      return "Employee ID is missing. Please login again.";
    }

    // Get Current Location
    Position? position = await getCurrentLocation();
    if (position == null) {
      return "Unable to fetch location. Ensure GPS is enabled.";
    }

    try {
      // Get File Details
      String fileExtension = getFileExtension(imageFile.path);
      String? mimeType = getMimeType(imageFile.path) ?? 'image/jpeg';
      print("📂 File Extension: $fileExtension | MIME Type: $mimeType");

      // Create Multipart Request
      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

      // Attach Form Data
      request.fields['emp_id'] = empId;
      request.fields['latitude'] = position.latitude.toString();  // Dynamic GPS Data
      request.fields['longitude'] = position.longitude.toString(); // Dynamic GPS Data
      request.fields['type'] = type;

      // Attach Image File with Proper MIME Type
      request.files.add(
        await http.MultipartFile.fromPath(
          imageKey,
          imageFile.path,
          filename: basename(imageFile.path),
          contentType: mimeType != null ? MediaType.parse(mimeType) : null,
        ),
      );

      // Send Request
      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(responseBody);
        bool success = responseData['success'] ?? false;
        String message = responseData['message'] ?? "Unknown error";

        if (success) {
          print("✅ $type Success: $message");
          await _saveImage(imageFile.path, type);
          return null;
        } else {
          print("🔴 $type Failed: $message");
          return message;
        }
      } else {
        print("🔴 $type Request Failed: ${response.reasonPhrase}");
        return "Server error: ${response.reasonPhrase}";
      }
    } catch (e) {
      print("🔴 Exception during $type: $e");
      return "Unexpected error occurred. Please try again.";
    }
  }

  /// Save Check-In/Check-Out Image with Date Key
  Future<void> _saveImage(String imagePath, String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String dateKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await prefs.setString("${type}_image_$dateKey", imagePath);
  }

  /// Retrieve Image Path for a Given Date (Check-In or Check-Out)
  Future<String?> getImage(String type, String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("${type}_image_$date");
  }

  /// Show dialog if location is not enabled (must be implemented in UI file)
  void showLocationErrorDialog() {
    print('Show loaction');
    // This method should be implemented in your UI file.
    // Call it from the UI using a callback if needed.
  }
}

