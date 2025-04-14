import 'dart:convert';
import 'package:employe_manage/API/encryption/Encryption_helper.dart';
import 'package:http/http.dart' as http;

class VersionService {
  static Future<Map<String, dynamic>?> checkAppVersion(String version) async {
    final encryptedType = EncryptionHelper.encryptString('checkAppVersion');
    final encryptedVersion = EncryptionHelper.encryptString(version);

    print('[DEBUG] Encrypted type: $encryptedType');
    print('[DEBUG] Encrypted version: $encryptedVersion');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis//checkAppVersion.php'),
    );

    request.fields.addAll({
      'type': encryptedType,
      'version': encryptedVersion,
    });
print("$encryptedVersion");
    print('[DEBUG] Sending request to: ${request.url}');
    print('[DEBUG] Request fields: ${request.fields}');

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
