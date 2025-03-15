import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Configuration/config_file.dart';
import '../Configuration/Custom_Animation.dart';
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
  bool isCheckedIn = false;
  int elapsedSeconds = 0;
  String userName = "Loading...";
  String jobRole = "Loading...";

  DateTime checkInTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // ✅ Fetch employee details from API
  }

  /// ✅ Fetch Employee Data from API
  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString('phone'); // Retrieve phone from shared preferences

    if (phone == null) {
      print("🔴 Phone number not found in SharedPreferences");
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis//emp_info.php'),
      );

      request.fields.addAll({
        'phone': phone, // ✅ Use stored phone number
        'type': 'user_info',
      });

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);

        if (jsonResponse['status'] == true) {
          if (jsonResponse.containsKey('data') && jsonResponse['data'] is Map<String, dynamic>) {
            var userData = jsonResponse['data']; // ✅ Extract data object

            setState(() {
              userName = userData['name'] ?? "Unknown";
              jobRole = userData['designation'] ?? "Unknown";
            });

            print("✅ User Data Fetched: $userName - $jobRole");
          } else {
            print("🔴 Missing 'data' key in API response: $jsonResponse");
          }
        } else {
          print("🔴 API Status Failure: ${jsonResponse['message']}");
        }
      } else {
        print("🔴 API Error: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("🔴 Exception in fetching user data: $e");
    }
  }

  void _startTimer() {
    elapsedSeconds = 0;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isCheckedIn) {
        timer.cancel();
      } else {
        setState(() {
          elapsedSeconds++;
        });
      }
    });
  }

  void onCheckIn() {
    setState(() {
      isCheckedIn = true;
      checkInTime = DateTime.now();
      elapsedSeconds = 0;
    });
    _startTimer();
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

            WelcomeCard(
              userName: isCheckedIn ? "" : userName,
              jobRole: isCheckedIn ? "" : jobRole,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              elapsedSeconds: isCheckedIn ? elapsedSeconds : 0,
              isCheckedIn: isCheckedIn,
              checkInTime: checkInTime,
            ),

            BottomCard(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),

            AppSpacing.medium(context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Leave Application', style: fontStyles.normalText),
                  TextButton(
                    onPressed: () {},
                    child: Text('See All', style: TextStyle(color: AppColors.secondary)),
                  ),
                ],
              ),
            ),


            // ✅ Responsive Leave Status Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomAnimation(initialText: 'Approved'),
                CustomAnimation(initialText: 'Pending'),
                CustomAnimation(initialText: 'Declined'),
              ],
            ),

            SizedBox(height: screenHeight * 0.02), // Responsive spacing

              ListView.builder(
                shrinkWrap: true,

                itemCount: leaveList.length,
                itemBuilder: (context, index) {
                  return CustomListTile(item: leaveList[index],
                    trailing: const CustomButton(),

                  );
                },
              ),

            SizedBox(height: screenHeight * 0.02),

            SlideCheckIn(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              isCheckedIn: isCheckedIn,
              onCheckIn: onCheckIn,
              onCheckOut: () {
                setState(() {
                  isCheckedIn = false;
                  elapsedSeconds = 0;
                });
              },
            ),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
