import 'dart:convert';
import 'package:employe_manage/API/encryption/Encryption_helper.dart';
import 'package:employe_manage/Configuration/app_constants.dart';
import 'package:http/http.dart' as http;

class VersionService {
  static Future<Map<String, dynamic>?> checkAppVersion(String version) async {


    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/checkAppVersion.php'),
    );

    request.fields.addAll({
      'type': EncryptionHelper.encryptString('checkAppVersion'),
      'version': EncryptionHelper.encryptString(version),
    });

    try {
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        print('[DEBUG] Raw response: $responseBody');

        final decoded = jsonDecode(responseBody);
        print('[DEBUG] Decoded response: $decoded');
        return decoded;
      } else {
        print('[ERROR] Request failed with status: ${response.statusCode}');
        print('[ERROR] Reason: ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('[ERROR] Exception while checking version: $e');
      return null;
    }
  }
}
