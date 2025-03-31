import 'package:employe_manage/Screens/leave_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API/Controllers/checkIn_Controller.dart';
import '../API/Services/user_service.dart';
import '../Configuration/app_spacing.dart';
import '../Configuration/style.dart';
import '../Widgets/Date_Picker.dart';
import '../Widgets/app_bar.dart';
import '../Widgets/bottom_card.dart';
import '../Widgets/leave_tab_view.dart';
import '../Widgets/slide_checkin.dart';
import '../Widgets/welcome_card.dart';

class WelcomePage extends StatefulWidget {
  final String title;
  const WelcomePage({super.key, required this.title});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final CheckInController checkInController = Get.put(CheckInController());
  final UserService userService = UserService();

  var userName = "Loading...".obs;
  var jobRole = "Loading...".obs;
  var employeeType = "Loading.".obs;
  var totalWorkedTime = "".obs;
  var selectedFirstIn = "N/A".obs;
  var selectedLastOut = "N/A".obs;
  var checkInImage = RxnString();
  var checkOutImage = RxnString();
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
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
    }
  }

  /// ✅ Fixed Function to Accept Five Parameters (Date, First-In, Last-Out, Check-in & Check-out Images)
  void _updateAttendance(DateTime selectedDate, String firstIn, String lastOut, String? checkInImg, String? checkOutImg) {
    setState(() {
      selectedFirstIn.value = firstIn;
      selectedLastOut.value = lastOut;
      checkInImage.value = checkInImg;
      checkOutImage.value = checkOutImg;
      /// ✅ Update selected month & year
      selectedYear = selectedDate.year;
      selectedMonth = selectedDate.month;
      });
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.03,
        ),
        child: Column(
          children: [
            /// ✅ Pass the updated function with correct parameters
            DatePickerDropdown(
              onDateSelected: _updateAttendance,
            ),
            AppSpacing.medium(context),
            Obx(() => WelcomeCard(
              userName: checkInController.isCheckedIn.value ? "" : userName.value,
              jobRole: checkInController.isCheckedIn.value ? "" : jobRole.value,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              elapsedSeconds: checkInController.elapsedSeconds.value,
              isCheckedIn: checkInController.isCheckedIn.value,
              checkInTime: checkInController.checkInTime.value ?? DateTime.now(),
              workedTime: checkInController.workedTime.value,
              checkOutTime: checkInController.checkOutTime.value ?? DateTime.now(),
              selectedFirstIn: selectedFirstIn.value,
              selectedLastOut: selectedLastOut.value,
              checkInImage: checkInImage.value,    // ✅ Pass Check-in Image
              checkOutImage: checkOutImage.value,
            )),
            BottomCard(screenWidth: screenWidth, screenHeight: screenHeight),
            AppSpacing.medium(context),
            Column(
              children: [
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
              ],
            ),
            LeaveTabView(
              heightFactor: 0.3,
              selectedMonth: selectedMonth,
              selectedYear: selectedYear,
            ),
            Obx(() => SlideCheckIn(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              isCheckedIn: checkInController.isCheckedIn.value,
              onCheckIn: () {
                checkInController.checkIn();
                _fetchUserData();
                totalWorkedTime.value = "";
              },
              onCheckOut: () {
                checkInController.checkOut();
                _fetchUserData();
                totalWorkedTime.value = checkInController.workedTime.value;
              },
            )),
          ],
        ),
      ),
    );
  }
}
