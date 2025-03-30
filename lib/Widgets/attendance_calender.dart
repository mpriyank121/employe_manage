import 'package:employe_manage/Widgets/Report_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../API/Services/attendance_service.dart';

class AttendanceCalendar extends StatefulWidget {
  final Function(DateTime, String, String, String?, String?)? onDateSelected;

  const AttendanceCalendar({super.key, this.onDateSelected}); // ✅ Updated Callback

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
      List<Map<String, dynamic>> data = await AttendanceService.fetchAttendanceData();

      if (mounted) {
        setState(() {
          attendanceData = {
            for (var record in data)
              DateTime.tryParse(record['date'] ?? "") ?? DateTime.now(): {
                "status": record['status'] ?? "N",
                "first_in": record['first_in'] ?? "N/A",
                "last_out": record['last_out'] ?? "N/A",
                "checkin_image": record['checkinImage'] ?? "",  // ✅ Added Check-in Image
                "checkout_image": record['checkoutImage'] ?? "", // ✅ Added Check-out Image
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

  /// ✅ Get Color Based on Attendance Status
  Color _getStatusColor(String status) {
    switch (status) {
      case "P":
        return Color(0xFFECF8F4);
      case "A":
        return Color(0x19C13C0B);
      case "W":
        return Color(0x1933B2E9);
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
                firstDay: DateTime(2025, 1, 1),
                lastDay: DateTime(2025, 12, 31),
                focusedDay: _focusedDay,
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
                    String checkinImage = attendanceData[normalizedDate]?['checkin_image'] ?? "";
                    String checkoutImage = attendanceData[normalizedDate]?['checkout_image'] ?? "";

                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(4),
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
                        if (checkinImage.isNotEmpty || checkoutImage.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (checkinImage.isNotEmpty) Icon(Icons.camera_alt, size: 12, color: Colors.green), // 📸 Check-in Icon
                              if (checkoutImage.isNotEmpty) Icon(Icons.camera_alt, size: 12, color: Colors.blue), // 📸 Check-out Icon
                            ],
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
