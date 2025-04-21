import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchPolicies({
  required String empId,
  required int limit,
  required int page,
  required int superUser, // optional usage depending on your API
}) async {
  final url = Uri.parse('https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/policy.php');

  var request = http.MultipartRequest('POST', url);
  request.fields.addAll({
    'type': 'get_policy',
    'emp_id': empId,
    'limit': limit.toString(),
    'offset': page.toString(),
  });

  try {
    http.StreamedResponse streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['found'] == true && responseData['PolicyData'] != null) {
        return responseData['PolicyData'];
      } else {
        return []; // No policies found
      }
    } else {
      throw Exception('Failed to load policies: ${response.reasonPhrase}');
    }
  } catch (e) {
    throw Exception('Error fetching policy data: $e');
  }
}
