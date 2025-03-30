import 'package:flutter/material.dart';
import 'attendance_calender.dart';

void showDatePickerBottomSheet(BuildContext context, Function(DateTime, String, String,String?,String?) onDateSelected) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: EdgeInsets.only(top: 20),
      child: AttendanceCalendar(
        onDateSelected: onDateSelected,

        // ✅ Callback to update date & times
      ),
    ),
  );
}
