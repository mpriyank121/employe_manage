import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Configuration/app_constants.dart';
import '../encryption/Encryption_helper.dart';

// Fetch Departments
Future<List<Map<String, String>>> getDepartment() async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/ticket.php'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {'type': EncryptionHelper.encryptString('get_department')},
    );

    if (response.statusCode == 200) {
      String responseBody = response.body;
      var jsonResponse = jsonDecode(responseBody);
      print("API Response (Departments): $responseBody");

      if (jsonResponse is Map && jsonResponse['status'] == true && jsonResponse['department'] is List) {
        return (jsonResponse['department'] as List)
            .map((dept) => {
          'id': dept['id'].toString(),  // Ensure ID is a String
          'department': dept['department'].toString(),
        })
            .toList();
      } else {
        print('Error: Invalid API response format for departments.');
        return [];
      }
    } else {
      print('Error: HTTP ${response.statusCode}, ${response.reasonPhrase}');
      return [];
    }
  } catch (e) {
    print('Request failed: $e');
    return [];
  }
}

// Fetch Employees by Department ID
Future<List<Map<String, String>>> getEmployeesByDepartment(List<String> departmentIds) async {
  try {
    // Prepare the form data by repeating the key for each value

    // Add department IDs dynamically (department_ids[])
    //
    final req =  http.MultipartRequest('POST',
      Uri.parse('$baseUrl/ticket.php'),
    );
    req.fields['type'] = EncryptionHelper.encryptString("get_employee");
    req.fields['emp_id'] = EncryptionHelper.encryptString("empId");
    for (int i = 0; i < departmentIds.length; i++) {
      req.fields['department_ids[$i]'] = EncryptionHelper.encryptString(departmentIds[i]);
    }
    var response = await req.send();
    var responseBody = await response.stream.bytesToString();

    print('resp:${responseBody}');
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseBody);
      bool success = jsonResponse['status'] ?? false;
      String message = jsonResponse['message'] ?? "Unknown error";

      if (success) {
        print("✅ Success: $message");
        if (jsonResponse is Map && jsonResponse['status'] == true && jsonResponse['employee'] is List) {
          return (jsonResponse['employee'] as List)
              .map((emp) =>
          {
            'empid': emp['empid'].toString(), // Ensure ID is a String
            'name': emp['name'].toString(),
          }).toList();
        }
      } else {
        print("🔴 Failed: $message");
        return [];
      }
    } else {
       print("🔴 Request Failed: \${response.reasonPhrase}");
       return [];
    }
  return [];
  } catch (e) {
    print('Request failed: $e');
    return [];
  }
}
