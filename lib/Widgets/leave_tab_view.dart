import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API/Services/leave_service.dart';
import 'CustomListTile.dart';
import 'Status_widget.dart';
import 'package:intl/intl.dart';
import 'package:employe_manage/API/models/leave_model.dart';
class LeaveTabView extends StatefulWidget {
  final double heightFactor;
  final int selectedYear;
  final int selectedMonth;
  final bool useCustomRange;

  const LeaveTabView({
    super.key,
    required this.heightFactor,
    required this.selectedYear,
    required this.selectedMonth,
    this.useCustomRange = false,
  });

  @override
  _LeaveTabViewState createState() => _LeaveTabViewState();
}
class _LeaveTabViewState extends State<LeaveTabView> {
  final RxMap<String, List<LeaveModel>> leaveData = <String, List<LeaveModel>>{}.obs;
  final isLoading = true.obs;

  @override
  void initState() {
    super.initState();
    _fetchLeaveData();
  }

  @override
  void didUpdateWidget(covariant LeaveTabView oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// ✅ Fetch new data when year or month changes
    if (widget.selectedYear != oldWidget.selectedYear || widget.selectedMonth != oldWidget.selectedMonth) {
      _fetchLeaveData();
    }
  }

  /// ✅ Fetch Leave Data Based on Employee ID
  void _fetchLeaveData() async {
    isLoading.value = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? empId = prefs.getString("emp_id");

    if (empId != null) {
      var data = await LeaveService.fetchLeaveData(empId);

      /// ✅ Force UI update after filtering
      leaveData.assignAll(_filterLeaveData(data));
      leaveData.refresh(); // 🔥 Ensures GetX detects the change
    }

    isLoading.value = false;
  }

  /// ✅ Custom or Normal Filtering Based on `useCustomRange`
  Map<String, List<LeaveModel>> _filterLeaveData(Map<String, List<LeaveModel>> data) {
    DateTime startDate, endDate;

    if (widget.useCustomRange) {
      if (widget.selectedMonth == 1) {
        startDate = DateTime(widget.selectedYear - 1, 12, 26);
        endDate = DateTime(widget.selectedYear, 1, 25);
      } else {
        startDate = DateTime(widget.selectedYear, widget.selectedMonth - 1, 26);
        endDate = DateTime(widget.selectedYear, widget.selectedMonth, 25);
      }
    } else {
      startDate = DateTime(widget.selectedYear, widget.selectedMonth, 1);
      endDate = DateTime(widget.selectedYear, widget.selectedMonth + 1, 0);
    }

    /// ✅ Filter leave data based on the selected range
    Map<String, List<LeaveModel>> filteredData = {};
    data.forEach((status, leaves) {
      filteredData[status] = leaves.where((leave) {
        DateTime leaveStart = DateTime.parse(leave.startDate);
        return leaveStart.isAfter(startDate.subtract(const Duration(days: 1))) &&
            leaveStart.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    });

    return filteredData;
  }

  /// ✅ Format Date as "Day, DD MMM YYYY"
  String _formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat("dd MMM").format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * widget.heightFactor,
      child: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (leaveData.isEmpty) {
          return const Center(child: Text("No leave data available"));
        }

        return DefaultTabController(
          length: leaveData.length,
          child: Column(
            children: [
              /// **📌 Dynamic Tab Bar**
              TabBar(
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                tabs: leaveData.keys.map((status) => Tab(child: Text(status))).toList(),
              ),

              /// **📜 Filtered Leave List**
              Expanded(
                child: TabBarView(
                  children: leaveData.entries.map((entry) {
                    return entry.value.isEmpty
                        ? const Center(child: Text("No leaves for this month"))
                        : ListView.builder(
                      itemCount: entry.value.length,
                      itemBuilder: (context, index) {
                        LeaveModel leave = entry.value[index];

                        return CustomListTile(
                          item: {
                            "title": leave.leaveName ?? "Leave Request",
                            "subtitle": "${_formatDate(leave.startDate)} - ${_formatDate(leave.endDate)}",
                          },
                          trailing: StatusWidget(status: leave.status),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
