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

  const AttendanceCalendar({super.key, this.onDateSelected,this.onMonthChanged}); // ✅ Updated Callback

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

  /// ✅ Fetch Attendance Data
  Future<void> _loadAttendanceData() async {
    try {
      List<Map<String, dynamic>> data = await AttendanceService.fetchAttendanceData(selectedYear, selectedMonth);

      if (mounted) {
        setState(() {
          attendanceData = {
            for (var record in data)
              DateTime.parse(record['date']).toLocal().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0): {
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

  /// ✅ Update Month & Year Navigation
  void _changeMonth(int step) {
    if ((DateTime.now().year >= selectedYear && step == -1 ||
        DateTime.now().year > selectedYear && step == 1) ||
        (DateTime.now().month > selectedMonth && DateTime.now().year == selectedYear)) {

      setState(() {
        selectedMonth += step;

        if (selectedMonth > 12) {
          selectedMonth = 1;
          selectedYear++;
        } else if (selectedMonth < 1) {
          selectedMonth = 12;
          if (selectedYear > 2000) selectedYear--;
        }

        _focusedDay = DateTime(selectedYear, selectedMonth, 1);
      });

      /// 🔁 Notify parent to update leave/holiday info
      widget.onMonthChanged?.call(selectedYear, selectedMonth);
      Get.find<HolidayController>().fetchHolidaysByMonth(selectedMonth);

    }
  }

  /// ✅ Get Color Based on Attendance Status
  Color _getStatusColor(String status) {
    switch (status) {
      case "P":
        return Color(0xFFB2DFDB); // Softer teal-green (Present)
      case "A":
        return Color(0xFFE57373); // Light red (Absent)
      case "W":
        return Color(0xFF64B5F6); // Soft blue (Work/Leave)
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
                enabledDayPredicate: (day) {
                  // Disable future dates
                  return !day.isAfter(DateTime.now());
                },

                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;

                  });


                  DateTime normalizedDate = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
                  Map<String, String>? record = attendanceData[normalizedDate];

                  String firstIn = (record?["first_in"]?.trim().isNotEmpty == true) ? record!["first_in"]! : "N/A";
                  String lastOut = (record?["last_out"]?.trim().isNotEmpty == true) ? record!["last_out"]! : "N/A";
                  String checkinImage = record?["checkin_image"] ?? ""; // ✅ Extracted Check-in Image
                  String checkoutImage = record?["checkout_image"] ?? ""; // ✅ Extracted Check-out Image

                  // ✅ Pass Data to Callback
                  widget.onDateSelected?.call(selectedDay, firstIn, lastOut, checkinImage, checkoutImage);

                  Navigator.pop(context);
                },
                calendarFormat: CalendarFormat.month,
                headerVisible: false, // 🔹 Hide default header

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
                    //print("🔍 Looking for status on: $normalizedDate | Found: ${attendanceData.containsKey(normalizedDate)}");


                    return Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width * 0.08, // 8% of screen width
                          width: MediaQuery.of(context).size.width * 0.08,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getStatusColor(status),
                          ),
                          child: Center(
                            child: Text(
                              "${date.day}",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                      ],
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
