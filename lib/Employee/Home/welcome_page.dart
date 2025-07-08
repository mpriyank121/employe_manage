// welcome_page.dart
import 'package:coreHrx_employeeapp/Widgets/leave_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'controller/welcome_page_controller.dart';
import '../../Widgets/app_bar.dart';
import '../../Widgets/date_picker_field.dart';
import '../Configuration/app_spacing.dart';
import 'Widgets/bottom_card.dart';
import 'Widgets/welcome_card.dart';
import 'Widgets/slide_checkin.dart';

class WelcomePage extends StatelessWidget {
  final String title;
  WelcomePage({Key? key, required this.title}) : super(key: key);

  final WelcomePageController controller = Get.put(WelcomePageController());

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width;
    final double screenHeight = size.height;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: title,
          leading: IconButton(
            icon: SvgPicture.asset('assets/images/green_logo.svg', height: 50),
            onPressed: () {},
          ),
          trailing: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                color: Colors.grey,
              )),
          showBackButton: false,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.small(context),
                Obx(() => CustomDatePickerBox(
                      selectedDate: controller.selectedDate.value,
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: controller.selectedDate.value,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          controller.updateSelectedDate(picked);
                        }
                      },
                    )),
                const SizedBox(height: 12),
                Obx(() => WelcomeCard(
                      userName: 'User',
                      jobRole: 'Role',
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      elapsedSeconds: 0,
                      isCheckedIn: false,
                      checkInTime: DateTime.now(),
                      checkOutTime: null,
                      selectedFirstIn: 'N/A',
                      selectedLastOut: 'N/A',
                      checkInImage: null,
                      checkOutImage: null,
                      checkInLocation: '',
                      checkOutLocation: '',
                      selectedDate: controller.selectedDate.value,
                    )),
                BottomCard(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
                AppSpacing.medium(context),
                const CategorySection(),
                AppSpacing.medium(context),
                LeaveApplicationTabs(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: screenHeight * 0.1,
          child: SlideCheckIn(
            showCam: false,
            text: 'Slide To CheckIn',
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isEnabled: true,
            isCheckedIn: false,
          ),
        ),
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  const CategorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'title': 'Attendance', 'color': Colors.orange.shade200},
      {'title': 'Leave', 'color': Colors.yellow.shade100},
      {'title': 'Remuneration', 'color': Colors.pink.shade100},
      {'title': 'Document', 'color': Colors.lightBlue.shade200},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'See All',
                style: TextStyle(fontSize: 14, color: Colors.deepOrange),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final item = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Column(
                  children: [
                    CircleAvatar(
                        radius: 25, backgroundColor: item['color'] as Color),
                    const SizedBox(height: 8),
                    Text(
                      item['title'] as String,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class LeaveApplicationTabs extends StatelessWidget {
  LeaveApplicationTabs({Key? key}) : super(key: key);

  final List<String> tabs = ['Approved', 'Pending', 'Declined'];
  final WelcomePageController controller = Get.find();

  final Map<String, List<Map<String, String>>> leaveData = {
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
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            children: leaveList.map((leave) {
              return LeaveRequestCard(
                title: leave['title']!,
                dateRange: leave['date']!,
                status: leave['status']!,
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}
