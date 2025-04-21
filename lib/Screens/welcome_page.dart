import 'package:employe_manage/Screens/leave_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API/Controllers/checkIn_Controller.dart';
import '../API/Controllers/employee_attendence_controller.dart';
import '../API/Controllers/leave_controller.dart';
import '../API/Controllers/update_controller.dart';
import '../API/Controllers/welcome_page_controller.dart';
import '../API/Services/attendance_service.dart';
import '../API/Services/user_service.dart';
import '../Configuration/app_spacing.dart';
import '../Configuration/style.dart';
import '../Widgets/Date_Picker.dart';
import '../Widgets/app_bar.dart';
import '../Widgets/bottom_card.dart';
import '../Widgets/leave_tab_view.dart';
import '../Widgets/slide_checkin.dart';
import '../Widgets/welcome_card.dart';
import 'package:intl/intl.dart';

import '../util/version_check.dart';

class WelcomePage extends StatefulWidget {
  final String title;
  const WelcomePage({super.key, required this.title});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final WelcomeController welcomeController = Get.put(WelcomeController());
  final CheckInController checkInController = Get.find<CheckInController>();
  final LeaveController leaveController = Get.find<LeaveController>();
  final AttendanceController attendanceController =Get.find<AttendanceController>();
  final updateController = Get.find<UpdateController>();
  bool _hasCheckedVersion = false;




  @override
  void initState() {
    super.initState();
    welcomeController.reloadWelcomeData();
    attendanceController.fetchAttendance();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasCheckedVersion) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        checkAppVersion();
      });
      _hasCheckedVersion = true;
    }
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(child: Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/bc 3.svg'),
          onPressed: () {},
        ),
      ),
      body: Obx(() {
        final isToday = welcomeController.selectedDate.value.isAtSameMomentAs(DateTime.now());

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                ),
                child: Column(
                  children: [
                    AppSpacing.small(context),
                    DatePickerDropdown(
                      onDateSelected: (date, firstIn, lastOut, checkInImages, checkOutImages,
                          checkInLocation, checkOutLocation) async {
                        String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                        var attendanceData = await AttendanceService.fetchAttendanceData(
                            date.year, date.month);
                        var attendance = await welcomeController.attendanceController
                            .getAttendanceByDate(formattedDate, attendanceData);



                        if (attendance == null) {
                          attendance = {
                            'first_in': "N/A",
                            'last_out': "N/A",
                            'checkIn_image': null,
                            'checkOut_image': null,
                            'checkInLocation': "N/A",
                            'checkOutLocation': "N/A",
                          };
                        }

                        welcomeController.updateAttendance(date, {
                          'first_in': attendance['first_in'] ?? "N/A",
                          'last_out': attendance['last_out'] ?? "N/A",
                          'checkIn_image': checkInImages,
                          'checkOut_image': checkOutImages,
                          'checkInLocation': checkInLocation,
                          'checkOutLocation': checkOutLocation,
                        });
                      },
                    ),
                    AppSpacing.small(context),
                    WelcomeCard(
                      userName: welcomeController.userName.value,
                      jobRole: welcomeController.jobRole.value,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
                      elapsedSeconds: checkInController.elapsedSeconds.value,
                      isCheckedIn: checkInController.isCheckedIn.value,
                      checkInTime: checkInController.checkInTime.value ?? DateTime.now(),
                      workedTime: checkInController.workedTime.value,
                      checkOutTime: checkInController.checkOutTime.value,
                      selectedFirstIn: welcomeController.selectedFirstIn.value,
                      selectedLastOut: welcomeController.selectedLastOut.value,
                      checkInImage: welcomeController.checkInImage.value,
                      checkOutImage: welcomeController.checkOutImage.value,
                      checkInLocation: welcomeController.checkInLocation.value,
                      checkOutLocation: welcomeController.checkOutLocation.value,
                      selectedDate: welcomeController.selectedDate.value,
                    ),

                    BottomCard(screenWidth: screenWidth, screenHeight: screenHeight),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Leave Application', style: fontStyles.headingStyle),
                        TextButton(
                          onPressed: () => Get.to(() => leavepage(title: "leave detail")),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Text('See All',
                              style: TextStyle(
                                  color: Color(0xFFF25922),
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400)),
                        ),
                      ],
                    ),
                    LeaveTabView(
                      heightFactor: 0.3,
                      selectedMonth: welcomeController.selectedDate.value.month,
                      selectedYear: welcomeController.selectedDate.value.year,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        final isToday = welcomeController.selectedDate.value.year == DateTime.now().year &&
            welcomeController.selectedDate.value.month == DateTime.now().month &&
            welcomeController.selectedDate.value.day == DateTime.now().day;

        return Container(
          height: screenHeight * 0.1,
          child: SlideCheckIn(
            showCam: welcomeController.showCam.value,
            text: welcomeController.selectedFirstIn.value == 'N/A'
                ? 'Slide To CheckIn'
                : welcomeController.selectedLastOut.value != 'N/A'
                ? 'Completed'
                : 'Slide To CheckOut',
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            isEnabled: isToday &&
                (welcomeController.selectedFirstIn.value == null ||
                    welcomeController.selectedFirstIn.value == "N/A" ||
                    (welcomeController.selectedFirstIn.value != "N/A" && welcomeController.selectedLastOut.value == "N/A") ||
                    (welcomeController.selectedFirstIn.value == null && welcomeController.selectedLastOut.value == null)),

            isCheckedIn: checkInController.isCheckedIn.value,
            onCheckIn: () async {
              await checkInController.checkIn();
              welcomeController.reloadWelcomeData();
            },
            onCheckOut: () async {
              await checkInController.checkOut();
              welcomeController.reloadWelcomeData();
            },
          ),

        );
      }),
    )) ;
  }
}
