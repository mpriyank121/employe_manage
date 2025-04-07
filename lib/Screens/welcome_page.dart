import 'package:employe_manage/Screens/leave_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API/Controllers/checkIn_Controller.dart';
import '../API/Controllers/employee_attendence_controller.dart';
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

class WelcomePage extends StatefulWidget {
  final String title;
  const WelcomePage({super.key, required this.title});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final CheckInController checkInController = Get.put(CheckInController());
  final UserService userService = UserService();
  final AttendanceController controller = Get.find<AttendanceController>();
  var isTodayAttendanceComplete = false.obs;


  var userName = "Loading...".obs;
  var jobRole = "Loading...".obs;
  var employeeType = "Loading...".obs;
  var totalWorkedTime = "".obs;
  var selectedFirstIn = "N/A".obs;
  var selectedLastOut = "N/A".obs;
  var checkInImage = RxnString();
  var checkOutImage = RxnString();
  var selectedDate = DateTime.now().obs;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _loadInitialAttendance();
  }

  Future<void> _fetchUserData() async {
    var userData = await userService.fetchUserData();
    if (userData != null) {
      userName.value = userData['name'] ?? "Unknown";
      jobRole.value = userData['designation'] ?? "Unknown";
      employeeType.value = userData['emp_type'] ?? "Unknown";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('emp_type', employeeType.value);
      await prefs.setString('username', userName.value);
      await prefs.setString('jobRole', jobRole.value);
      await _loadInitialAttendance();
      print('Attendance data :$_loadInitialAttendance()');

    }
  }
  Future<void> _loadInitialAttendance() async {
    var attendanceData = await AttendanceService.fetchAttendanceData(selectedYear,selectedMonth);
    print("📦 All Attendance Data: $attendanceData");

    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    var todayAttendance = await controller.getAttendanceByDate(formattedDate, attendanceData);
    if (todayAttendance != null && todayAttendance['first_in'] != null) {
      checkInController.setFirstInAndStartTimer(todayAttendance['first_in']!);
    }
    print('First in raw value: ${todayAttendance['first_in']}');

    if (todayAttendance == null || todayAttendance.isEmpty) {

    }
print('to:::$todayAttendance');
    print("🖼️ Final Images -> CheckIn: ${todayAttendance['checkIn_image']} | CheckOut: ${todayAttendance['checkOut_image']}");

    _updateAttendance(DateTime.now(), todayAttendance);
  }


  void _updateAttendance(DateTime newSelectedDate, Map<String, dynamic> attendance) {
    setState(() {
      selectedDate.value = newSelectedDate;
      selectedFirstIn.value = attendance['first_in'] ?? "N/A";
      selectedLastOut.value = attendance['last_out'] ?? "N/A";
      checkInImage.value = attendance['checkIn_image'];
      checkOutImage.value = attendance['checkOut_image'];
      selectedYear = newSelectedDate.year;
      selectedMonth = newSelectedDate.month;
      isTodayAttendanceComplete.value =
          attendance['first_in'] != null &&
              attendance['first_in'] != "N/A" &&
              attendance['last_out'] != null &&
              attendance['last_out'] != "N/A";
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool isToday = selectedDate.value.isAtSameMomentAs(DateTime.now());

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/bc 3.svg'),
          onPressed: () {},
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.05,
                vertical: screenHeight * 0.03,
              ),
              child: Column(
                children: [
                  DatePickerDropdown(
                  onDateSelected: (date, firstIn, lastOut, checkInImages, checkOutImages) async {
            print("🔹 Selected Date: $date");
            print("🔹 Initial Values -> First In: $firstIn, Last Out: $lastOut, Check-In Image: $checkInImage, Check-Out Image: $checkOutImage");
            setState(() {
              checkInImage.value = checkInImages;
              checkOutImage.value = checkOutImages;
            });
            var attendanceData = await AttendanceService.fetchAttendanceData(selectedYear,selectedMonth);
            print("✅ Attendance Data Fetched: ${attendanceData.length} records");

            // ✅ Convert DateTime to String before passing
            String formattedDate = DateFormat('yyyy-MM-dd').format(date);
            print("📆 Formatted Date: $formattedDate");

            var attendance = await controller.getAttendanceByDate(formattedDate, attendanceData);
            print("🔎 Fetched Attendance for Date: $formattedDate -> $attendance");

            // ✅ Check if attendance is null or missing expected keys
            if (attendance == null) {
            print("⚠️ No attendance record found for $formattedDate");
            attendance = {
            'first_in': "N/A",
            'last_out': "N/A",
            'checkIn_image': null,
            'checkOut_image': null
            };
            }

            print("📝 Updating Attendance State");
            _updateAttendance(date, {
            'first_in': attendance['first_in'] ?? "N/A",
            'last_out': attendance['last_out'] ?? "N/A",
            'checkIn_image': checkInImages,
            'checkOut_image': checkOutImages,
            });
            },
            ),

              AppSpacing.medium(context),
                  Obx(() => WelcomeCard(
                    userName: userName.value,
                    jobRole: jobRole.value,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    elapsedSeconds: checkInController.elapsedSeconds.value,
                    isCheckedIn: checkInController.isCheckedIn.value,
                    checkInTime: checkInController.checkInTime.value ?? DateTime.now(),
                    workedTime: isToday ? checkInController.workedTime.value : "",
                    checkOutTime: checkInController.checkOutTime.value,
                    selectedFirstIn: selectedFirstIn.value,
                    selectedLastOut: selectedLastOut.value,
                    checkInImage: checkInImage.value,
                    checkOutImage: checkOutImage.value,
                    selectedDate: selectedDate.value,
                  )),
                  BottomCard(screenWidth: screenWidth, screenHeight: screenHeight),
                  AppSpacing.medium(context),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Leave Application', style: fontStyles.headingStyle),
                      TextButton(
                        onPressed: () {
                          Get.to(leavepage(title: "leave detail"));
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                            color: Color(0xFFF25922),
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 1.60,
                            letterSpacing: 0.20,
                          ),
                        ),
                      )
                    ],
                  ),
                  LeaveTabView(
                    heightFactor: 0.3,
                    selectedMonth: selectedMonth,
                    selectedYear: selectedYear,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: screenHeight * 0.13,
        padding: EdgeInsets.all(10),
        child: Obx(() => SlideCheckIn(
          text: selectedFirstIn.value == 'N/A'?'Slide To CheckIn':selectedLastOut.value!='N/A'?'Completed':'Slide To CheckOut',
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          isEnabled: !isTodayAttendanceComplete.value, // 👈 Pass this to gray it out
          isCheckedIn: checkInController.isCheckedIn.value,
          onCheckIn: ()async {
           await checkInController.checkIn();         // ✅ Mark check-in
            _loadInitialAttendance(); // 🔁 Refresh attendance
          },
          onCheckOut: ()async {
           await checkInController.checkOut();        // ✅ Mark check-out
            _loadInitialAttendance(); // 🔁 Refresh attendance
          },

        )),
      ),
    );
  }
}
