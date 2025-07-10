import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportController extends GetxController {
  final workModes = [
    'Present (WFH) Office',
    'Remote Work',
    'On Leave',
    'WFH',
  ];

  var selectedWorkMode = 'Present (WFH) Office'.obs;
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().add(Duration(days: 1)).obs;
  var clockIn = TimeOfDay(hour: 10, minute: 0).obs;
  var clockOut = TimeOfDay(hour: 19, minute: 0).obs;
  var note = ''.obs;

  final dateFormatter = DateFormat('dd/MM/yyyy');
  final timeFormatter = DateFormat('hh:mm a');

  void setWorkMode(String mode) {
    selectedWorkMode.value = mode;
  }

  void setFromDate(DateTime date) {
    fromDate.value = date;
    if (toDate.value.isBefore(date)) {
      toDate.value = date;
    }
  }

  void setToDate(DateTime date) {
    toDate.value = date;
    if (fromDate.value.isAfter(date)) {
      fromDate.value = date;
    }
  }

  void setClockIn(TimeOfDay time) {
    clockIn.value = time;
  }

  void setClockOut(TimeOfDay time) {
    clockOut.value = time;
  }

  void setNote(String val) {
    note.value = val;
  }

  Future<void> pickDate(BuildContext context, bool isFrom) async {
    final initialDate = isFrom ? fromDate.value : toDate.value;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      if (isFrom) {
        setFromDate(picked);
      } else {
        setToDate(picked);
      }
    }
  }

  Future<void> pickTime(BuildContext context, bool isClockIn) async {
    final initialTime = isClockIn ? clockIn.value : clockOut.value;
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      if (isClockIn) {
        setClockIn(picked);
      } else {
        setClockOut(picked);
      }
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return timeFormatter.format(dt);
  }

  String formatDate(DateTime date) => dateFormatter.format(date);
}
