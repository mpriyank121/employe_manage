import 'dart:io';
import 'package:employe_manage/Configuration/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

import '../encryption/Encryption_helper.dart';

class CheckInService {
  final String _baseUrl = '$baseUrl/checkIn.php';
  String? _cachedEmpId; // cache empId

  /// Save Employee ID
  Future<void> saveEmpId(String empId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("emp_id", empId);
    _cachedEmpId = empId; // cache it
  }

  /// Retrieve Employee ID
  Future<String?> _getEmpId() async {
    if (_cachedEmpId != null) return _cachedEmpId;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cachedEmpId = prefs.getString("emp_id");
    return _cachedEmpId;
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
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("📡 Location services are disabled.");
        return null;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("📡 Location permission denied.");
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print("📡 Location permission denied forever.");
        return null;
      }


      // Then try getting current position with timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 8));

      print("📍 Got current location: $position");
      return position;
    } catch (e) {
      print("❌ Location error: $e");
      return null;
    }
  }


  /// Perform Check-In with Image Upload
  Future<bool> performCheckIn(File? imageFile) async {
    return await uploadImageAndPerformAction(imageFile, 'checkin', 'checkIn_image') == null;
  }

  /// Perform Check-Out with Image Upload
  Future<bool> performCheckOut(File? imageFile) async {
    return await uploadImageAndPerformAction(imageFile, 'checkout', 'checkOut_image') == null;
  }

  /// Upload Image and Perform Check-In/Check-Out
  Future<String?> uploadImageAndPerformAction(File? imageFile, String type, String imageKey) async {
    final empIdFuture = _getEmpId();
    final locationFuture = getCurrentLocation();

    final empId = await empIdFuture;
    final position = await locationFuture;

    if (empId == null || position == null) {
      return "Missing employee ID or location.";
    }

    try {
      String? mimeType;
      if (imageFile != null) {
        mimeType = getMimeType(imageFile.path) ?? 'image/jpeg';
        print("📂 MIME Type: $mimeType");
      }

      var request = http.MultipartRequest('POST', Uri.parse(_baseUrl));

      request.fields['emp_id'] = EncryptionHelper.encryptString(empId);
      request.fields['latitude'] = EncryptionHelper.encryptString(position.latitude.toString());
      request.fields['longitude'] = EncryptionHelper.encryptString(position.longitude.toString());
      request.fields['type'] = EncryptionHelper.encryptString(type);

            if (imageFile != null && imageFile.path.isNotEmpty && await imageFile.exists()) {
        print("📤 Uploading image file: ${imageFile.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            imageKey,
            imageFile.path,
            filename: basename(imageFile.path),
            contentType: mimeType != null ? MediaType.parse(mimeType) : null,
          ),
        );
      } else if (imageFile != null) {
        print("⚠️ Image file not found or invalid: ${imageFile.path}");
        return "Image file does not exist.";
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(responseBody);
        bool success = responseData['success'] ?? false;
        String message = responseData['message'] ?? "Unknown error";

        if (success) {
          print("✅ $type Success: $message");
          if (imageFile != null && imageFile.path.isNotEmpty) {
          await _saveImage(imageFile.path, type);
}

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
    print('Show Location');
  }

  /// Check if employee is within allowed radius
  Future<String?> checkEmployeeRadius() async {
    final empIdFuture = _getEmpId();
    final locationFuture = getCurrentLocation();

    final empId = await empIdFuture;
    final position = await locationFuture;

    if (empId == null || position == null) {
      return "Unable to fetch required info for radius check.";
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/checkIn.php'),
      );

      request.fields.addAll({
        'type': EncryptionHelper.encryptString('checkEmployeeRadius'),
        'emp_id': EncryptionHelper.encryptString(empId),
        'longitude': EncryptionHelper.encryptString(position.longitude.toString()),
        'latitude': EncryptionHelper.encryptString(position.latitude.toString()),
      });

      http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("✅ Radius Check Success: $responseBody");
        return responseBody;
      } else {
        print("🔴 Radius Check Failed: ${response.reasonPhrase}");
        return "Server error: ${response.reasonPhrase}";
      }
    } catch (e) {
      print("🔴 Exception during radius check: $e");
      return "Unexpected error occurred. Please try again.";
    }
  }
  /// Radius check using provided position (avoids duplicate location calls)
Future<String?> checkEmployeeRadiusWithPosition(Position position) async {
  final empId = await _getEmpId();
  if (empId == null) return "Employee ID missing.";

  try {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/checkIn.php'),
    );

    request.fields.addAll({
      'type': EncryptionHelper.encryptString('checkEmployeeRadius'),
      'emp_id': EncryptionHelper.encryptString(empId),
      'longitude': EncryptionHelper.encryptString(position.longitude.toString()),
      'latitude': EncryptionHelper.encryptString(position.latitude.toString()),
    });

    http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print("✅ Radius Check Success: $responseBody");
      return responseBody;
    } else {
      print("🔴 Radius Check Failed: ${response.reasonPhrase}");
      return "Server error: ${response.reasonPhrase}";
    }
  } catch (e) {
    print("🔴 Exception during radius check: $e");
    return "Unexpected error occurred. Please try again.";
  }
}

}
