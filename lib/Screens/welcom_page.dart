import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../API/Controllers/checkIn_Controller.dart';
import '../API/Services/user_service.dart';
import '../Configuration/Custom_Animation.dart';
import '../Configuration/app_colors.dart';
import '../Configuration/app_spacing.dart';
import '../Configuration/style.dart';
import '../Widgets/CustomListTile.dart';
import '../Widgets/app_bar.dart';
import '../Widgets/bottom_card.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/leave_list.dart';
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
    }
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
            _buildDateContainer(screenWidth),
            AppSpacing.medium(context),

            Obx(() => WelcomeCard(
              userName: checkInController.isCheckedIn.value ? "" : userName.value,
              jobRole: checkInController.isCheckedIn.value ? "" : jobRole.value,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              elapsedSeconds: checkInController.elapsedSeconds.value,
              isCheckedIn: checkInController.isCheckedIn.value,
              checkInTime: checkInController.checkInTime.value,
              workedTime: checkInController.workedTime.value,
            )),

            BottomCard(screenWidth: screenWidth, screenHeight: screenHeight),
            AppSpacing.medium(context),

            _buildLeaveSummary(),
            AppSpacing.medium(context),

            _buildLeaveList(),

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

  Widget _buildDateContainer(double screenWidth) {
    return Container(
      width: screenWidth * 0.9,
      height: 50,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.primary),
          borderRadius: BorderRadius.circular(screenWidth * 0.1),
        ),
      ),
      child: Center(
        child: Text('11 - Jan - 2024', style: fontStyles.headingStyle),
      ),
    );
  }

  Widget _buildLeaveSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomAnimation(initialText: 'Approved'),
        CustomAnimation(initialText: 'Pending'),
        CustomAnimation(initialText: 'Declined'),
      ],
    );
  }

  Widget _buildLeaveList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: leaveList.length,
      itemBuilder: (context, index) {
        return CustomListTile(item: leaveList[index], trailing: const CustomButton());
      },
    );
  }
}
