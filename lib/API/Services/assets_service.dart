import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Configuration/app_constants.dart';
import '../encryption/Encryption_helper.dart';

class AssetService {
  final String apiUrl = '$baseUrl/asset_info.php';

  /// Fetches assets dynamically for a given employee ID
  Future<List<Map<String, dynamic>>> fetchAssets(String empId) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? empId = prefs.getString("emp_id");
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    request.fields.addAll({
      'emp_id': EncryptionHelper.encryptString(empId!), // ✅ Dynamic Employee ID
      'type': EncryptionHelper.encryptString('asset'),
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

      if (jsonResponse["status"] == true) {
        return List<Map<String, dynamic>>.from(jsonResponse["assetData"]);
      } else {
        throw Exception("Error fetching assets: ${jsonResponse['message']}");
      }
    } else {
      throw Exception("Failed to load assets: ${response.reasonPhrase}");
    }
  }
}