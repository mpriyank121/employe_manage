import 'package:employe_manage/Widgets/Reason_view_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../API/Controllers/leave_controller.dart';
import 'CustomListTile.dart';
import 'Custom_dialog.dart';
import 'No_data_found.dart';
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
          return const Center(child: const NoDataWidget(
            message: "No Leaves found",
            imagePath: "assets/images/Error_image.png", // your image path
          ));
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
                        ? const NoDataWidget(
                      imageHeight: 150,
                      message: "No Leaves found",
                      imagePath: "assets/images/Error_image.png", // your image path
                    )
                        : ListView.builder(
                      itemCount: entry.value.length,
                      itemBuilder: (context, index) {
                        LeaveModel leave = entry.value[index];

                        return  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey, // Border color
                                width: 1,         // Border width
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top section: Title + Dates + Status
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Title and Dates
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              leave.leaveName ?? "Leave Request",
                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "${_formatDate(leave.startDate)} - ${_formatDate(leave.endDate)}",
                                              style: const TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Status badge
                                      StatusWidget(status: leave.status),
                                    ],
                                  ),
                                ),

                                // Divider
                                const Divider(height: 1, color: Color(0xFFE0E0E0)),

                                // Buttons section
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (leave.comment != "NA" && leave.comment!.trim().isNotEmpty)
                                        ReasonViewButton(
                                          text: "View Comment",
                                          color: Color(0xFF3CAB88),
                                          onPressed: () => showCustomDialog(context, "Comment", leave.comment ?? "No comment available"),
                                        ),
                                      const SizedBox(width: 8),
                                      ReasonViewButton(
                                        text: "View Reason",
                                        color: Colors.red,
                                        onPressed: () => showCustomDialog(context, "Reason", leave.resson ?? "No reason provided"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
