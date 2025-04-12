import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Configuration/app_constants.dart';
import '../encryption/Encryption_helper.dart';

// Fetch Ticket Categories
Future<List<Map<String, String>>> getTicketCategories() async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/ticket.php'),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {'type': EncryptionHelper.encryptString('get_ticket_Cat')},
    );

    if (response.statusCode == 200) {
      String responseBody = response.body;
      var jsonResponse = jsonDecode(responseBody);
      print("API Response (Ticket Categories): $responseBody");

      if (jsonResponse is Map && jsonResponse['status'] == true && jsonResponse['ticket_cat_data'] is List) {
        return (jsonResponse['ticket_cat_data'] as List)
            .map((category) => {
          'id': category['id'].toString(),
          'category_name': category['category_name'].toString(),
          'ticket_cat_id': category['id'].toString(), // Fetching ticket_cat_id for subcategories
        })
            .toList();
      } else {
        print('Error: Invalid API response format for categories.');
        return [];
      }
    } else {
      print('Error: HTTP \${response.statusCode}, \${response.reasonPhrase}');
      return [];
    }
  } catch (e) {
    print('Request failed: \$e');
    return [];
  }
}
// Fetch Subcategories by Category ID

Future<List<Map<String, String>>> getSubCategoriesByCategory(List<String> categoryIds) async {
  try {
    final req = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/ticket.php'),
    );

    req.fields['type'] = EncryptionHelper.encryptString("get_ticket_subCat");

    for (String categoryId in categoryIds) {
      req.fields['ticket_catID'] = EncryptionHelper.encryptString(categoryId);
    }

    var response = await req.send();
    var responseBody = await response.stream.bytesToString();

    print("📩 API Response (Subcategories): $responseBody");

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(responseBody);
      bool success = jsonResponse['status'] ?? false;
      String message = jsonResponse['message'] ?? "Unknown error";

      if (success) {
        print("✅ Success: $message");

        if (jsonResponse['ticket_cat_data'] is List) {
          return (jsonResponse['ticket_cat_data'] as List)
              .map((subcategory) => {
            'id': subcategory['id'].toString(),
            'category_name': subcategory['category_name'].toString(),
          })
              .toList();
        }
      } else {
        print("🔴 API Failed: $message");
      }
    } else {
      print("🔴 Request Failed: ${response.reasonPhrase}");
    }
  } catch (e) {
    print("❌ Exception occurred: $e");
  }

  return [];
}
