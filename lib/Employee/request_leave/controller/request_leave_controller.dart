

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class RequestLeaveController extends GetxController {
  // Reactive fields
  RxString selectedLeaveType = 'Casual'.obs;
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  RxString attachmentPath = ''.obs;

  // Plain controller (not reactive, no need)
  final TextEditingController aboutNote = TextEditingController();

  // Dropdown options
  final List<String> leaveTypes = ['Casual', 'Sick', 'Earned', 'Maternity'];

  // Setters
  void setLeaveType(String? type) {
    if (type != null) selectedLeaveType.value = type;
  }

  void setFromDate(DateTime date) {
    fromDate.value = date;
  }

  void setToDate(DateTime date) {
    toDate.value = date;
  }

  void setAttachment(String path) {
    attachmentPath.value = path;
  }

  void resetForm() {
    selectedLeaveType.value = 'Casual';
    fromDate.value = DateTime.now();
    toDate.value = DateTime.now();
    aboutNote.clear();
    attachmentPath.value = '';
  }

  @override
  void onClose() {
    aboutNote.dispose();
    super.onClose();
  }
}
