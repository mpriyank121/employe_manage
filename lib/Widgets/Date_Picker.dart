import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Configuration/ui_styles.dart';
import 'bottom_sheet_helper.dart';

class DatePickerDropdown extends StatefulWidget {
  final Function(DateTime, String, String) onDateSelected;

  const DatePickerDropdown({Key? key, required this.onDateSelected}) : super(key: key);

  @override
  _DatePickerDropdownState createState() => _DatePickerDropdownState();
}

class _DatePickerDropdownState extends State<DatePickerDropdown> {
  DateTime selectedDate = DateTime.now();
  String selectedFirstIn = "N/A";
  String selectedLastOut = "N/A";

  void _updateDate(DateTime newDate, String firstInTime, String lastOutTime) {
    setState(() {
      selectedDate = newDate;
      selectedFirstIn = firstInTime.isNotEmpty ? firstInTime : "N/A";
      selectedLastOut = lastOutTime.isNotEmpty ? lastOutTime : "N/A";
    });

    /// ✅ Now passing selectedDate to parent along with first-in and last-out times
    widget.onDateSelected(selectedDate, selectedFirstIn, selectedLastOut);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDatePickerBottomSheet(context, _updateDate),
      child: AnimatedContainer(
        duration: UIStyles.animationDuration,
        curve: UIStyles.animationCurve,
        padding: UIStyles.dropdownPadding,
        decoration: UIStyles.dropdownDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, color: Colors.grey[700]),
            SizedBox(width: 5),
            Text(
              DateFormat('dd - MMM - yyyy').format(selectedDate),
              style: UIStyles.dateTextStyle,
            ),
            SizedBox(width: 5),
            Icon(Icons.arrow_drop_down, color: Colors.grey[700]),
          ],
        ),
      ),
    );
  }
}
