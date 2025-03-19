import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Configuration/app_cards.dart';

class DatePickerDropdown extends StatefulWidget {
  final VoidCallback onCalendarTap; // Function to open your CalendarWidget

  const DatePickerDropdown({Key? key, required this.onCalendarTap}) : super(key: key);

  @override
  _DatePickerDropdownState createState() => _DatePickerDropdownState();
}

class _DatePickerDropdownState extends State<DatePickerDropdown> {
  DateTime selectedDate = DateTime.now();
  String selectedOption = 'Option 1'; // Default dropdown value

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Date Picker Container (Triggers CalendarWidget)
        GestureDetector(
          onTap: widget.onCalendarTap, // Calls the provided function
          child: AnimatedContainer(

            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: ShapeDecoration(
              color: TileConfig.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),

                side: const BorderSide(width: 1, color: TileConfig.borderColor),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.grey[700]),
                    SizedBox(width: 5),
                    Text(
                      DateFormat('dd - MMM - yyyy').format(selectedDate),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_drop_down, color: Colors.grey[700]),

                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
