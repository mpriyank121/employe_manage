import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchTickets({required String empId, int limit = 10, int page = 1}) async {
  try {
    var url = Uri.parse('https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis//ticket.php');
    var request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'type': 'ticketList',
      'limit': limit.toString(),
      'page': page.toString(),
      'emp_id': empId,
      'super_user': '0',
    });

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseBody);

      if (jsonResponse['success'] == "success") {
        return jsonResponse['list'] ?? []; // ✅ Fetch from "list" key
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to load tickets');
      }
    } else {
      throw Exception("Error: ${response.reasonPhrase}");
    }
  } catch (e) {
    throw Exception("Error: $e");
  }
}
