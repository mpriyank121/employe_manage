import 'package:employe_manage/Widgets/Report_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../API/Controllers/holiday_controller.dart';
import '../API/Services/attendance_service.dart';

class AttendanceCalendar extends StatefulWidget {
  final Function(DateTime, String, String, String?, String?)? onDateSelected;
  final void Function(int year, int month)? onMonthChanged;

  const AttendanceCalendar({super.key, this.onDateSelected, this.onMonthChanged});

  @override
  _AttendanceCalendarState createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  Map<DateTime, Map<String, String>> attendanceData = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  /// ✅ Helper to normalize date (removes time component)
  DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  /// ✅ Fetch Attendance Data
  Future<void> _loadAttendanceData() async {
    try {
      List<Map<String, dynamic>> data = await AttendanceService.fetchAttendanceData(selectedYear, selectedMonth);

      if (mounted) {
        setState(() {
          attendanceData = {
            for (var record in data)
              _normalizeDate(DateTime.parse(record['date'])): {
                "status": record['status'] ?? "N",
                "first_in": record['first_in'] ?? "N/A",
                "last_out": record['last_out'] ?? "N/A",
                "checkin_image": record['checkinImage'] ?? "",
                "checkout_image": record['checkoutImage'] ?? "",
              }
          };
        });
      }
      print("✅ Attendance Data Loaded: $attendanceData");
    } catch (e) {
      print("🔴 Error fetching attendance: $e");
    }
  }

  /// ✅ Month Navigation (restrict future)
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

    DateTime newFocusedDay = DateTime(newYear, newMonth);
    if (newFocusedDay.isAfter(DateTime.now())) return;

    setState(() {
      selectedMonth = newMonth;
      selectedYear = newYear;
      _focusedDay = newFocusedDay;
    });

    widget.onMonthChanged?.call(selectedYear, selectedMonth);
    Get.find<HolidayController>().fetchHolidaysByMonth(selectedMonth);
  }

  /// ✅ Get Color Based on Attendance Status
  Color _getStatusColor(String status) {
    switch (status) {
      case "P":
        return Color(0xFFB2DFDB); // Present
      case "A":
        return Color(0xFFE57373); // Absent
      case "W":
        return Color(0xFF64B5F6); // Work/Leave
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
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
                  "${DateFormat.MMM().format(DateTime(selectedYear, selectedMonth))} $selectedYear",
                  style: TextStyle(
                    color: Color(0xFFF25922),
                    fontSize: 22,
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

          SizedBox(height: MediaQuery.of(context).size.height * 0.012),

          Card(
            child: Container(
              width: screenWidth * 0.9,
              decoration: BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(8.0),
              child: TableCalendar(
                firstDay: DateTime(2000, 1, 1),
                lastDay: DateTime(2025, 12, 31),
                focusedDay: _focusedDay,
                enabledDayPredicate: (day) => !day.isAfter(DateTime.now()),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  DateTime normalizedDate = _normalizeDate(selectedDay);
                  Map<String, String>? record = attendanceData[normalizedDate];

                  String firstIn = (record?["first_in"]?.trim().isNotEmpty == true) ? record!["first_in"]! : "N/A";
                  String lastOut = (record?["last_out"]?.trim().isNotEmpty == true) ? record!["last_out"]! : "N/A";
                  String checkinImage = record?["checkin_image"] ?? "";
                  String checkoutImage = record?["checkout_image"] ?? "";

                  widget.onDateSelected?.call(selectedDay, firstIn, lastOut, checkinImage, checkoutImage);
                  Navigator.pop(context);
                },
                calendarFormat: CalendarFormat.month,
                headerVisible: false,

                calendarStyle: CalendarStyle(
                  outsideDaysVisible: true,
                  todayDecoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  defaultTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),

                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, _) {
                    DateTime normalizedDate = DateTime(date.year, date.month, date.day);
                    String status = attendanceData[normalizedDate]?['status'] ?? "N";

                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },


                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
