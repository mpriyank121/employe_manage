import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = "https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/";

  /// ✅ Common POST request method
  Future<dynamic> postRequest(String endpoint, Map<String, String> body) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl + endpoint),
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("🔴 API Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("🔴 Exception in API Request: $e");
      return null;
    }
  }
}
