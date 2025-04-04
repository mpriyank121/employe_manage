import 'package:employe_manage/Widgets/Reason_view_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../API/Controllers/leave_controller.dart';
import 'CustomListTile.dart';
import 'Custom_dialog.dart';
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
  final LeaveController leaveController = Get.put(LeaveController());

  @override
  void initState() {
    super.initState();
    leaveController.fetchLeaveData(widget.selectedYear, widget.selectedMonth, widget.useCustomRange);
  }

  @override
  void didUpdateWidget(covariant LeaveTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedYear != oldWidget.selectedYear || widget.selectedMonth != oldWidget.selectedMonth) {
      leaveController.fetchLeaveData(widget.selectedYear, widget.selectedMonth, widget.useCustomRange);
    }
  }

  void showCustomDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(title: title, content: content),
    );
  }

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
        if (leaveController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (leaveController.leaveData.isEmpty) {
          return const Center(child: Text("No leave data available"));
        }

        return DefaultTabController(
          length: leaveController.leaveData.length,
          child: Column(
            children: [
              TabBar(
                labelColor: Colors.orange,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,
                tabs: leaveController.leaveData.keys.map((status) => Tab(child: Text(status))).toList(),
              ),
              Expanded(
                child: TabBarView(
                  children: leaveController.leaveData.entries.map((entry) {
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
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              StatusWidget(status: leave.status),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (leave.comment != "NA" && leave.comment!.trim().isNotEmpty)
                                    ReasonViewButton(
                                      text: "View Comment",
                                      color: Colors.grey,
                                      onPressed: () => showCustomDialog(context, "Comment", leave.comment ?? "No comment available"),
                                    ),
                                  const SizedBox(width: 4),
                                  ReasonViewButton(
                                    text: "View Reason",
                                    color: Colors.grey,
                                    onPressed: () => showCustomDialog(context, "Reason", leave.resson ?? "No reason provided"),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
