import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Configuration/app_constants.dart';

Future<void> applyTicket({
  required String empId,
  required List<String> departments,
  required List<String> employeeOptions,
  required String startDate,
  required String priority,
  required String ticketTitle,
  required String description,
  required String ticketCat,
  String? ticketSubCat,
  required String orderId,
  required String attendanceDate,
}) async {
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('$baseUrl/ticket.php'),
  );

  request.fields.addAll({
    'type': 'apply_ticket',
    'emp_id': empId,
    'priority': priority,
    'ticket_title': ticketTitle,
    'description': description,
    'ticket_cat': ticketCat,
    'start_date': startDate,
    'order_id' : orderId,
    'attendance_date' : attendanceDate,
  });

  if (ticketSubCat != null) request.fields['ticket_sub_cat'] = ticketSubCat;
  if (orderId != null) request.fields['order_id'] = orderId;
  if (attendanceDate != null) request.fields['attendance_date'] = attendanceDate;

  for (var i = 0; i<departments.length;i++) {
    request.fields['departments[$i]'] = departments[i];
  }

  for (var i=0; i<employeeOptions.length;i++) {
    request.fields['employee_option[$i]'] = employeeOptions[i];
  }

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    String responseBody = await response.stream.bytesToString();
    print("✅ Response: $responseBody");
  } else {
    print("❌ Error: ${response.reasonPhrase}");
  }
}
