import 'package:coreHrx_employeeapp/Employee/Attendance/Widgets/attendance_calender.dart';
import 'package:coreHrx_employeeapp/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:coreHrx_employeeapp/Widgets/App_bar.dart';
import '../Configuration/Leave_Card_colors.dart';
import '../Configuration/app_spacing.dart';
import '../Leave/Widgets/Leave_card.dart';

class AttendancePage extends StatelessWidget {
  final String title;

  const AttendancePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Attendance',
          showBackButton: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.small(context),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          LeaveCard(
                            title: "Present",
                            count: '0',
                            backgroundColor:
                                blendWithWhite(LeaveColors.present),
                            borderColor: LeaveColors.present,
                          ),
                          LeaveCard(
                            title: "Absent",
                            count: '2',
                            backgroundColor: blendWithWhite(LeaveColors.absent),
                            borderColor: LeaveColors.absent,
                          ),
                          LeaveCard(
                            title: "Half Day",
                            count: '0',
                            backgroundColor:
                                blendWithWhite(LeaveColors.halfDay),
                            borderColor: LeaveColors.halfDay,
                          ),
                          LeaveCard(
                            title: "Sick Leave",
                            count: '0',
                            backgroundColor:
                                blendWithWhite(LeaveColors.sickLeave),
                            borderColor: LeaveColors.sickLeave,
                          ),
                          LeaveCard(
                            title: "Casual Leave",
                            count: '0',
                            backgroundColor:
                                blendWithWhite(LeaveColors.casualLeave),
                            borderColor: LeaveColors.casualLeave,
                          ),
                          LeaveCard(
                            title: "Earned Leave",
                            count: '0',
                            backgroundColor:
                                blendWithWhite(LeaveColors.earnedLeave),
                            borderColor: LeaveColors.earnedLeave,
                          ),
                          LeaveCard(
                            title: "Off",
                            count: '0',
                            backgroundColor: blendWithWhite(LeaveColors.off),
                            borderColor: LeaveColors.off,
                          ),
                          LeaveCard(
                            title: "Holiday",
                            count: '0',
                            backgroundColor:
                                blendWithWhite(LeaveColors.holiday),
                            borderColor: LeaveColors.holiday,
                          ),
                        ],
                      ),
                    ),
                  ),
                  AttendanceCalendar(
                    onDateSelected: null,
                    onMonthChanged: null,
                    popOnDateTap: false,
                  ),
                  AttendanceStatusCard(
                    date: '01 Mon 2024',
                    status: 'Present',
                    clockIn: '09:00 AM',
                    clockOut: '09:00 AM',
                  ),
                  AttendanceStatusCard(
                    date: '02 Mon 2024',
                    status: 'Absent',
                    isEditable: true,
                  ),
                  AttendanceStatusCard(
                    date: '03 Mon 2024',
                    status: 'Present (WFH)',
                    clockIn: '09:00 AM',
                    clockOut: '05:00 PM',
                  ),
                  // _EditableRequestSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AttendanceStatusCard extends StatelessWidget {
  final String date;
  final String status;
  final String? clockIn;
  final String? clockOut;
  final bool isEditable;

  const AttendanceStatusCard({
    super.key,
    required this.date,
    required this.status,
    this.clockIn,
    this.clockOut,
    this.isEditable = false,
  });

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'present (wfh)':
        return Colors.teal;
      case 'absent':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(status);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        //  color: Colors.orange.withOpacity(0.05),
        border: Border.all(color: statusColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  border: Border.all(color: statusColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                      color: statusColor, fontWeight: FontWeight.w600),
                ),
              )
            ],
          ),
          if (clockIn != null && clockOut != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text('Clock In $clockIn'),
                  const SizedBox(width: 16),
                  Text('Clock Out $clockOut'),
                ],
              ),
            ),
          if (isEditable) _EditableRequestSection(),
        ],
      ),
    );
  }
}

class _EditableRequestSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Clock In',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Clock Out',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text("Total Hours : 9 Hours",
              style: TextStyle(color: Colors.green)),
          const SizedBox(height: 10),
          const TextField(
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Note',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: "Cancel",
                  buttonColor:
                      Colors.orange.withOpacity(0.1), // Custom color for cancel
                  textColor: Colors.deepOrange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: PrimaryButton(
                  text: "Save",
                  onPressed: () {},
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
