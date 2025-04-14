import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Configuration/app_constants.dart';
import '../encryption/Encryption_helper.dart';

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
    'type':EncryptionHelper.encryptString('apply_ticket') ,
    'emp_id': EncryptionHelper.encryptString(empId),
    'priority': EncryptionHelper.encryptString(priority),
    'ticket_title': EncryptionHelper.encryptString(ticketTitle),
    'description': EncryptionHelper.encryptString(description),
    'ticket_cat': EncryptionHelper.encryptString(ticketCat),
    'start_date': EncryptionHelper.encryptString(startDate),
    'order_id' : EncryptionHelper.encryptString(orderId),
    'attendance_date' : EncryptionHelper.encryptString(attendanceDate),
  });

  if (ticketSubCat != null) request.fields['ticket_sub_cat'] = EncryptionHelper.encryptString(ticketSubCat);
  if (orderId != null) request.fields['order_id'] = EncryptionHelper.encryptString(orderId);
  if (attendanceDate != null) request.fields['attendance_date'] = EncryptionHelper.encryptString(attendanceDate);

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
