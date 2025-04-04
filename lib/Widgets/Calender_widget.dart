import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  // Function to update month & year
  void changeMonth(int step) {
    setState(() {
      selectedMonth += step;
      if (selectedMonth > 12) {
        selectedMonth = 1;
        selectedYear++;
      } else if (selectedMonth < 1) {
        selectedMonth = 12;
        selectedYear--;
      }
      _focusedDay = DateTime(selectedYear, selectedMonth, 1);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        // Month-Year Selector Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Arrow Button
            IconButton(
              onPressed: () => changeMonth(-1),
              icon: SvgPicture.asset('assets/images/chevron-u.svg'),
            ),

            // Month & Year Text
            Text(
              "${DateFormat.MMM().format(DateTime(selectedYear, selectedMonth))} $selectedYear",
              style: TextStyle(
                color: Color(0xFFF25922),
                fontSize: 22,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
              ),
            ),
            // Right Arrow Button
            IconButton(
              onPressed: () => changeMonth(1),
              icon: SvgPicture.asset('assets/images/chevron-up.svg'),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.012), // 1.2% of screen height

        // Calendar Widget
        Card(
        child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TableCalendar(
        firstDay: DateTime(2000),
        lastDay: DateTime.now(),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
        setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        });
        },
    calendarFormat: CalendarFormat.month,
    headerVisible: false, // Hide default header
    // **Calendar Style**
    calendarStyle: CalendarStyle(
    outsideDaysVisible: false, // Hide previous & next month dates
    // **Today’s Date Style (Orange Circle)**
    todayDecoration: BoxDecoration(
    color: Colors.orange,
    shape: BoxShape.circle,
    ),

    // **Selected Date Style (Bordered)**
    selectedDecoration: BoxDecoration(
    shape: BoxShape.rectangle,

    ),

    // **Weekend Style**
    weekendTextStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),

    // **Default Day Style**
    defaultTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),

    // **Custom Days of Week Style**
    daysOfWeekStyle: DaysOfWeekStyle(
    weekendStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    ),
    ),
    ),
    )

    ],
    );
  }
}
