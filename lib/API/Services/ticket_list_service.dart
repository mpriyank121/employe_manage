import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../Configuration/app_constants.dart';
import '../encryption/Encryption_helper.dart';

Future<List<dynamic>> fetchTickets({required String empId, int limit = 100, int page=1,  required int superUser
}) async {

  try {
    print('📥 super_user from prefs: $superUser'); // should be '0' or '2'
    var url = Uri.parse('$baseUrl//ticket.php');
    var request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'type': EncryptionHelper.encryptString('ticketList'),
      'limit': (limit.toString()),
      'page': (page.toString()),
      'emp_id': EncryptionHelper.encryptString(empId),
      'super_user': EncryptionHelper.encryptString(superUser.toString()),
    });

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    print('ishere:$responseBody');

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseBody);
print('aasas:$responseBody');
print('jsdj$superUser');
print(('pageee:$page'));


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