import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../API/Controllers/check_in_controller.dart';
import '../API/Services/user_service.dart';
import '../Configuration/Custom_Animation.dart';
import '../Configuration/config_file.dart';
import '../Configuration/style.dart';
import '../Widgets/App_bar.dart';
import '../Widgets/Bottom_card.dart';
import '../Widgets/CustomListTile.dart';
import '../Widgets/Welcome_card.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/leave_list.dart';
import '../Widgets/slide_checkin.dart';

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
  var totalWorkedTime = "".obs; // ✅ Stores total worked time after checkout

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  /// ✅ Fetch User Data
  Future<void> _fetchUserData() async {
    var userData = await userService.fetchUserData();
    if (userData != null) {
      userName.value = userData['name'] ?? "Unknown";
      jobRole.value = userData['designation'] ?? "Unknown";
      print("✅ User Data Fetched: ${userName.value} - ${jobRole.value}");
    }
  }

  /// ✅ Convert elapsed seconds into HH:MM:SS format
  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
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
            Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.06,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: AppColors.primary),
                  borderRadius: BorderRadius.circular(screenWidth * 0.1),
                ),
              ),
              child: Center(
                child: Text('11 - Jan - 2024', style: fontStyles.headingStyle),
              ),
            ),
            AppSpacing.medium(context),

            /// ✅ Welcome Card - Updates in real-time
            Obx(() => WelcomeCard(
              userName: checkInController.isCheckedIn.value ? "" : userName.value,
              jobRole: checkInController.isCheckedIn.value ? "" : jobRole.value,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              elapsedSeconds: checkInController.elapsedSeconds.value,
              isCheckedIn: checkInController.isCheckedIn.value,
              checkInTime: checkInController.checkInTime.value,
              workedTime: checkInController.workedTime.value, // ✅ Now updates after checkout
            )),

            BottomCard(screenWidth: screenWidth, screenHeight: screenHeight),
            AppSpacing.medium(context),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomAnimation(initialText: 'Approved'),
                CustomAnimation(initialText: 'Pending'),
                CustomAnimation(initialText: 'Declined'),
              ],
            ),
            AppSpacing.medium(context),

            ListView.builder(
              shrinkWrap: true,
              itemCount: leaveList.length,
              itemBuilder: (context, index) {
                return CustomListTile(item: leaveList[index], trailing: const CustomButton());
              },
            ),

            /// ✅ Slide Check-In Button - Updates Welcome Card and Timer in real-time
            SlideCheckIn(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              isCheckedIn: checkInController.isCheckedIn.value,
              onCheckIn: () {
                checkInController.checkIn();
                _fetchUserData(); // ✅ Refresh user data
                totalWorkedTime.value = ""; // ✅ Clear total worked time on check-in
              },
              onCheckOut: () {
                checkInController.checkOut();
                _fetchUserData(); // ✅ Refresh user data

                /// ✅ Save the total worked time after checkout
                totalWorkedTime.value = formatTime(checkInController.elapsedSeconds.value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
