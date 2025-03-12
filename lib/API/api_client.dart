import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = "https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/";

  /// ✅ Generic POST request function
  Future<Map<String, dynamic>?> postRequest(String endpoint, Map<String, String> body) async {
    try {
      var url = Uri.parse("$baseUrl$endpoint");
      var request = http.MultipartRequest('POST', url);

      request.fields.addAll(body);

      var response = await request.send();
      String responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(responseData);
        return jsonResponse;
      } else {
        print("🔴 API Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("🔴 Exception in postRequest: $e");
      return null;
    }
  }
}
