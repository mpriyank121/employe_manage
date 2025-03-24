import 'dart:convert';
import 'package:http/http.dart' as http;

class AssetService {
  final String apiUrl = 'https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis//asset_info.php';

  /// Fetches assets dynamically for a given employee ID
  Future<List<Map<String, dynamic>>> fetchAssets(String empId) async {
    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

    request.fields.addAll({
      'emp_id': empId, // ✅ Dynamic Employee ID
      'type': 'asset',
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
