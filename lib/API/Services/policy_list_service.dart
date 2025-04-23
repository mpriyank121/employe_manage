import 'dart:convert';
import 'package:employe_manage/Configuration/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<dynamic>> fetchPolicies({
  required String empId,
  required int limit,
  required int page,
  required int superUser, // optional usage depending on your API
}) async {
  final url = Uri.parse('$baseUrl/policy.php');

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

Future<bool> handlePolicyAction(dynamic policyId, String status) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final empId = prefs.getString('emp_id');

    if (empId == null) {
      throw Exception("Employee ID not found in SharedPreferences");
    }

    final url = Uri.parse('$baseUrl/policy.php');
    final request = http.MultipartRequest('POST', url);

    request.fields.addAll({
      'type': 'policy_action',
      'id': policyId.toString(),
      'emp_id': empId,
      'status': status,
    });

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print('✅ Policy Action Response: $responseBody');
      return true;
    } else {
      print('❌ Policy Action Failed: ${response.reasonPhrase}');
      return false;
    }
  } catch (e) {
    print('⚠️ Error submitting policy action: $e');
    return false;
  }
}
