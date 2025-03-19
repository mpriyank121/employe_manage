import 'package:employe_manage/Widgets/CustomListTile.dart';
import 'package:flutter/material.dart';
import '../API/Services/leave_service.dart';
import '../API/models/leave_model.dart';
import 'package:intl/intl.dart';

import 'Status_widget.dart';


class LeaveTabView extends StatelessWidget {
  final double heightFactor;

  const LeaveTabView({super.key, required this.heightFactor});

  @override
  Widget build(BuildContext context) {
    String formatDate(String dateString) {
      DateTime date = DateTime.parse(dateString); // Parse the string to DateTime
      return DateFormat('dd MMM').format(date); // Format to "Jan 10, 2024"
    }
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * heightFactor, // ✅ Customizable height
      child: FutureBuilder<Map<String, List<LeaveModel>>>(
        future: LeaveService.fetchLeaveData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No leave data available"));
          }

          var leaveData = snapshot.data!;
          print("📜 Leave Data: $leaveData"); // ✅ Debugging: Print fetched data

          return DefaultTabController(
            length: leaveData.length,
            child: Column(
              children: [TabBar(
                labelColor: Colors.orange, // Selected text color
                unselectedLabelColor: Colors.grey, // Unselected text color
                indicatorColor: Colors.transparent,
                dividerColor: Colors.transparent,

                tabs: leaveData.keys.map((status) =>
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2), // Add padding for better spacing
                        child: Text(
                          status,
                          style: TextStyle(),
                        ),
                      ),
                    ),
                ).toList(),
              ),


                /// **Leave List UI**
                Expanded(
                  child: TabBarView(
                    children: leaveData.entries.map((entry) {
                      return ListView.builder(
                        itemCount: entry.value.length,
                        itemBuilder: (context, index) {
                          LeaveModel leave = entry.value[index];

                          return CustomListTile(
                            item: {
                              "title": leave.status ?? "Leave Request",
                              "subtitle": "${formatDate(leave.startDate)} - ${formatDate(leave.endDate)}",
                            },
                            trailing:StatusWidget(status: leave.status), // Use StatusWidget here
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
