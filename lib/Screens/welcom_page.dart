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
  var totalWorkedTime = "".obs;
  var selectedFirstIn = "N/A".obs;
  var selectedLastOut = "N/A".obs;
  int selectedMonth = DateTime.now().month; // Defaults to current month
  int selectedYear = DateTime.now().year; // Defaults to current year


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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', userName.value);
      await prefs.setString('jobRole', jobRole.value);
      userName.value = userName.value;
      jobRole.value = jobRole.value;
    }
  }

  void _updateAttendance(DateTime selectedDate, String firstIn, String lastOut) {
    setState(() {
      selectedFirstIn.value = firstIn;
      selectedLastOut.value = lastOut;

      /// ✅ Keep month & year as selected date's values
      selectedYear = selectedDate.year;
      selectedMonth = selectedDate.month;

      print("📅 Selected Date: ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}");
      print("🕒 First In: $selectedFirstIn, Last Out: $selectedLastOut");
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
            DatePickerDropdown(
              onDateSelected: _updateAttendance, // ✅ Pass update function
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
            )),
            BottomCard(screenWidth: screenWidth, screenHeight: screenHeight,
              ),
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
            LeaveTabView(heightFactor: 0.3,
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
