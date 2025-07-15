import 'package:coreHrx_employeeapp/Employee/Holidays/controller/holiday_controller.dart';
import 'package:coreHrx_employeeapp/Employee/Holidays/widget/holiday_widget_list.dart';
import 'package:coreHrx_employeeapp/Employee/Leave/Widgets/Request_leave_form.dart';
import 'package:coreHrx_employeeapp/Employee/Leave/controller/leave_controller.dart';
import 'package:coreHrx_employeeapp/Employee/request_leave/request_leave.dart';
import 'package:coreHrx_employeeapp/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Widgets/App_bar.dart';
import '../../Widgets/year_selector.dart';

class LeavePage extends StatelessWidget {
  final String title;
  const LeavePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeaveController(), permanent: true);
    final holidayController = Get.put(HolidayController(), permanent: true);
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: title),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() => YearMonthSelector(
                    initialYear: controller.selectedYear.value,
                    initialMonth: controller.selectedMonth.value,
                    onDateChanged: (year, month) {
                      controller.updateDate(year, month);
                    },
                  )),
              totalLeaveSection(),
              SizedBox(height: screenHeight * 0.02),
              LeaveApplicationTabs(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                height: screenHeight * 0.05,
                color: Colors.grey.shade200,
                child: Center(child: Text("Holidays This Month")),
              ),
              Container(
                child: Obx(() => HolidayList(
                      holidays: holidayController.holidays,
                      isLoading: holidayController.isLoading.value,
                    )),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: PrimaryButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: Colors.white),
                  text: "Request Leave",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget totalLeaveSection() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Casual Leave Card
          InkWell(
            onTap: () {
              Get.to(() => RequestLeave());
            },
            child: Container(
              width: MediaQuery.of(Get.context!).size.width *
                  0.45, // Adjusted width
              height: 75,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 1.5),
                borderRadius: BorderRadius.circular(10),
                color: Colors.green.shade50,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 24, color: Colors.green),
                    SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Casual Leave",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "3/12",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Sick Leave Card
          Container(
            width:
                MediaQuery.of(Get.context!).size.width * 0.45, // Adjusted width
            height: 75,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 1.5),
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue.shade50,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Icon(Icons.calendar_month, size: 24, color: Colors.blue),
                  SizedBox(width: 12),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sick Leaves",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "4/20",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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

class LeaveApplicationTabs extends StatelessWidget {
  LeaveApplicationTabs({Key? key}) : super(key: key);

  final List<String> tabs = ['Pending', 'Approved', 'Declined'];
  final controller = Get.find<LeaveController>();

  final Map<String, List<Map<String, String>>> leaveData = {
    'Pending': [
      {
        'title': 'Sick Leave Request',
        'date': '12 Jan - 14 Jan',
        'status': 'Pending'
      },
      {
        'title': 'Casual Leave Request',
        'date': '12 Jan - 14 Jan',
        'status': 'Pending'
      },
    ],
    'Approved': [
      {
        'title': 'Sick Leave Request',
        'date': '12 Jan - 14 Jan',
        'status': 'Approved'
      },
      {
        'title': 'Casual Leave Request',
        'date': '12 Jan - 14 Jan',
        'status': 'Approved'
      },
    ],
    'Declined': [
      {
        'title': 'Sick Leave Request',
        'date': '12 Jan - 14 Jan',
        'status': 'Declined'
      },
      {
        'title': 'Casual Leave Request',
        'date': '12 Jan - 14 Jan',
        'status': 'Declined'
      },
    ],
  };

  Color _getTabColor(int index, {bool background = false}) {
    final selected = controller.selectedIndex.value == index;
    if (!selected) return background ? Colors.transparent : Colors.grey;

    switch (tabs[index]) {
      case 'Approved':
        return background ? Colors.green.shade50 : Colors.green;
      case 'Pending':
        return background ? Colors.orange.shade50 : Colors.orange;
      case 'Declined':
        return background ? Colors.red.shade50 : Colors.red;
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedTab = tabs[controller.selectedIndex.value];
      final leaveList = leaveData[selectedTab]!;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Leave Application',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('See All',
                    style: TextStyle(fontSize: 14, color: Colors.deepOrange)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(tabs.length, (index) {
              final isSelected = controller.selectedIndex.value == index;
              return GestureDetector(
                onTap: () => controller.changeTab(index),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: _getTabColor(index, background: true),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 14,
                      color: _getTabColor(index),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Column(
            children: List.generate(leaveList.length, (index) {
              final leave = leaveList[index];
              return LeaveDetailsCard(
                title: leave['title']!,
                dateRange: leave['date']!,
                status: leave['status']!,
                index: index,
                tab: selectedTab,
              );
            }),
          ),
        ],
      );
    });
  }
}

class LeaveDetailsCard extends StatelessWidget {
  final String title;
  final String dateRange;
  final String status;
  final int index;
  final String tab;

  LeaveDetailsCard({
    Key? key,
    required this.title,
    required this.dateRange,
    required this.status,
    required this.index,
    required this.tab,
  }) : super(key: key);

  final controller = Get.find<LeaveController>();

  Color getStatusColor() {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Declined':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isExpanded = controller.isExpanded(tab, index);

      return GestureDetector(
        onTap: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.toggleExpanded(tab, index);
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                /// Top Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Title and date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        const Text("8 Jan, 2024",
                            style: TextStyle(fontSize: 13, color: Colors.grey)),
                      ],
                    ),

                    /// Status badge with arrow icon
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: getStatusColor(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Text(status,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(width: 4),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 20,
                            color: Colors.white,
                          )
                        ],
                      ),
                    )
                  ],
                ),

                /// Expanded content
                if (isExpanded) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text("Leave Date: $dateRange, 2 Days"),
                  ),
                  const SizedBox(height: 12),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Notes:",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Hello, I'm not feeling well and need to request days of sick leave. I've included my doctor's note for your review. Thank you for your understanding.",
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  if (status == "Pending")
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text("Edit",
                          style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold)),
                    )
                ],
              ],
            ),
          ),
        ),
      );
    });
  }
}
