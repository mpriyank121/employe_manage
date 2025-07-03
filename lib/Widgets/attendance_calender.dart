import 'package:employe_manage/Configuration/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../Configuration/Leave_Card_colors.dart';

class AttendanceCalendar extends StatefulWidget {
  final Function(
      DateTime,
      String,
      String,
      String?,
      String?,
      String?,
      String?
      )? onDateSelected;
  final bool popOnDateTap;

  final void Function(int year, int month)? onMonthChanged;

  const AttendanceCalendar({super.key, this.onDateSelected, this.onMonthChanged, this.popOnDateTap = false});

  @override
  _AttendanceCalendarState createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  Map<DateTime, Map<String, String>> attendanceData = {};

  // Current month focused day
  DateTime _currentMonthFocusedDay = DateTime.now();

  // Previous month focused day
  DateTime _previousWeekFocusedDay = DateTime.now();

  DateTime? _selectedDay;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
  }

  void _updateFocusedDays() {
    // Current month focused on 15th
    _currentMonthFocusedDay = DateTime(selectedYear, selectedMonth, 15);

    // Previous month focused day
    int prevMonth = selectedMonth == 1 ? 12 : selectedMonth - 1;
    int prevYear = selectedMonth == 1 ? selectedYear - 1 : selectedYear;
    _previousWeekFocusedDay = DateTime(prevYear, prevMonth, 15);
  }

  /// ✅ Normalize Date (removes time part)
  DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  /// ✅ Get last week of previous month (25th to last day)
  Map<String, DateTime> _getPreviousWeekRange() {
    // Get previous month and year
    int prevMonth = selectedMonth == 1 ? 12 : selectedMonth - 1;
    int prevYear = selectedMonth == 1 ? selectedYear - 1 : selectedYear;

    // Always start from 25th of previous month
    DateTime startDate = DateTime(prevYear, prevMonth, 26);

    // End date is the last day of previous month
    DateTime endDate = DateTime(selectedYear, selectedMonth, 1).subtract(Duration(days: 1));

    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }

  /// ✅ Get current month range
  Map<String, DateTime> _getCurrentMonthRange() {
    DateTime startDate = DateTime(selectedYear, selectedMonth, 1);
    int nextMonth = selectedMonth == 12 ? 1 : selectedMonth + 1;
    int nextYear = selectedMonth == 12 ? selectedYear + 1 : selectedYear;
    DateTime endDate = DateTime(nextYear, nextMonth, 1).subtract(Duration(days: 1));

    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }


  /// ✅ Month Navigation
  void _changeMonth(int step) {
    int newMonth = selectedMonth + step;
    int newYear = selectedYear;

    if (newMonth > 12) {
      newMonth = 1;
      newYear++;
    } else if (newMonth < 1) {
      newMonth = 12;
      newYear--;
    }

    // Allow only up to next month from current date
    DateTime now = DateTime.now();
    int maxMonth = now.month + 1;
    int maxYear = now.year;

    if (maxMonth > 12) {
      maxMonth = 1;
      maxYear++;
    }

    if (newYear > maxYear || (newYear == maxYear && newMonth > maxMonth)) {
      return;
    }

    setState(() {
      selectedMonth = newMonth;
      selectedYear = newYear;
    });

    _updateFocusedDays();
    widget.onMonthChanged?.call(selectedYear, selectedMonth);

  }


  /// ✅ Get Color Based on Attendance Status
  Color _getStatusColor(String status) {
    switch (status) {
      case "P":
        return LeaveColors.present; // Present
      case "A":
        return LeaveColors.absent; // Absent
      case "HD":
        return LeaveColors.halfDay;
      case "SL":
        return LeaveColors.sickLeave; // Sick Leave
      case "CL":
        return LeaveColors.casualLeave; // Casual Leave
      case "EL":
        return LeaveColors.earnedLeave; // Earned Leave
      case "LWP":
        return LeaveColors.absent;
      case "SP":
        return LeaveColors.present;// speacial leav
      case "Off":
        return LeaveColors.off;
      case "H":
        return LeaveColors.holiday; // Holiday
      case "HW":
        return LeaveColors.present; //Holiday work
      default:
        return Colors.transparent;
    }
  }

  /// ✅ Handle date selection for both calendars
  void _handleDateSelection(DateTime selectedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });

    DateTime normalizedDate = _normalizeDate(selectedDay);
    Map<String, String>? record = attendanceData[normalizedDate];

    String firstIn = (record?["first_in"]?.trim().isNotEmpty == true) ? record!["first_in"]! : "N/A";
    String lastOut = (record?["last_out"]?.trim().isNotEmpty == true) ? record!["last_out"]! : "N/A";
    String checkinImage = record?["checkin_image"] ?? "";
    String checkoutImage = record?["checkout_image"] ?? "";

    widget.onDateSelected?.call(
      selectedDay,
      firstIn,
      lastOut,
      checkinImage,
      checkoutImage,
      record?['checkInLocation'] ?? '',
      record?['checkOutLocation'] ?? '',
    );

    if (widget.popOnDateTap) {
      Navigator.pop(context);
    }
  }

  /// ✅ Build calendar cell
  Widget _buildCalendarCell(BuildContext context, DateTime date, Map<String, DateTime> dateRange, {bool isSelected = false}) {
    DateTime normalizedDate = _normalizeDate(date);
    String status = attendanceData[normalizedDate]?['status'] ?? "";

    bool isInRange = !normalizedDate.isBefore(dateRange['startDate']!) &&
        !normalizedDate.isAfter(dateRange['endDate']!);

    String displayText = date.day.toString();
    if (["SL", "CL", "EL", "LWP", "HW", "H","SP","Off"].contains(status)) {
      displayText = status;
    }

    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: isInRange ? _getStatusColor(status) : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        displayText,
        style: TextStyle(
          color: isInRange ? Colors.black : Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    final prevWeekRange = _getPreviousWeekRange();
    final currentMonthRange = _getCurrentMonthRange();

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          AppSpacing.small(context),
          // Navigation Header
          Container(
            width: screenWidth * 0.9,
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => _changeMonth(-1),
                  icon: SvgPicture.asset('assets/images/chevron-u.svg'),
                ),
                Text(
                  "${DateFormat('26 MMM ').format(_previousWeekFocusedDay)} to ${DateFormat('25 MMM ').format(_currentMonthFocusedDay)}",
                  style: TextStyle(
                    color: Color(0xFFF25922),
                    fontSize: 20,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                  ),
                ),

                IconButton(
                  onPressed: () => _changeMonth(1),
                  icon: SvgPicture.asset('assets/images/chevron-up.svg'),
                ),
              ],
            ),
          ),
          // Current Month Calendar
          Card(
            child: Container(
              width: screenWidth * 0.9,
              decoration: BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  // Current month header
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      DateFormat('MMMM yyyy').format(_currentMonthFocusedDay),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFF25922),
                      ),
                    ),
                  ),
                  // Current month calendar
                  TableCalendar(
                    firstDay: DateTime(2000, 1, 1),
                    lastDay: DateTime(2030, 12, 31),
                    focusedDay: _currentMonthFocusedDay,
                    selectedDayPredicate: (day) => _selectedDay != null &&
                        _normalizeDate(day) == _normalizeDate(_selectedDay!),
                    availableGestures: AvailableGestures.none,

                    enabledDayPredicate: (day) {
                      final now = DateTime.now();
                      final isToday = day.year == now.year && day.month == now.month && day.day == now.day;
                      final isFuture = day.isAfter(DateTime(now.year, now.month, now.day));
                      final isDisabledRange = day.day >= 26 && day.day <= 31;

                      // Don't disable today
                      if (isToday) return true;

                      return !isFuture && !isDisabledRange;
                    },



                    calendarFormat: CalendarFormat.month,
                    startingDayOfWeek: StartingDayOfWeek.monday,

                    onDaySelected: (selectedDay, focusedDay) {
                      _handleDateSelection(selectedDay);
                    },

                    headerVisible: false,

                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      todayDecoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      weekendTextStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      defaultTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      disabledTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade400),
                    ),

                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekendStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),

                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, date, _) => _buildCalendarCell(context, date, currentMonthRange),
                      selectedBuilder: (context, date, _) => _buildCalendarCell(context, date, currentMonthRange, isSelected: true),
                      todayBuilder: (context, date, _) {
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            date.day.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}