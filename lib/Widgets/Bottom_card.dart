import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../API/Controllers/employee_attendence_controller.dart';
import '../Configuration/app_cards.dart';

class BottomCard extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const BottomCard({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Ensure Controller is Registered Before Using
    final AttendanceController controller = Get.find<AttendanceController>();

    return Container(
      height: screenHeight*0.08,
      padding: EdgeInsets.only(top:6), // Add top padding
      decoration: BoxDecoration(
        color: BottomCardConfig.backgroundColor,

        border: Border(
          bottom: BorderSide(color: BottomCardConfig.borderColor, width: BottomCardConfig.borderWidth), // ✅ Bottom Border
          left: BorderSide(color: BottomCardConfig.borderColor, width: BottomCardConfig.borderWidth), // ✅ Left Border
          right: BorderSide(color: BottomCardConfig.borderColor, width: BottomCardConfig.borderWidth), // ✅ Right Border
          top: BorderSide.none, // ❌ No Top Border
        ),

        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(BottomCardConfig.borderRadius),
          bottomRight: Radius.circular(BottomCardConfig.borderRadius),
        ),
      ),
      child: Row(

        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // ✅ Worked Days
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Worked Days', textAlign: TextAlign.center, style: BottomCardConfig.commonTextStyle),
                Obx(() => Text(
                  '${controller.present.value} Days',
                  textAlign: TextAlign.center,
                  style: BottomCardConfig.commonTextStyle,
                )),
              ],
            ),
          ),

          // ✅ Separator
          Container(
            width: screenWidth * BottomCardConfig.separatorWidthFactor,
            height: screenHeight * BottomCardConfig.separatorHeightFactor,
            color: BottomCardConfig.separatorColor,
          ),

          // ✅ Absent Days
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Weekoff', textAlign: TextAlign.center, style: BottomCardConfig.commonTextStyle),
                Obx(() => Text(
                  '${controller.week_off.value} Days',
                  textAlign: TextAlign.center,
                  style: BottomCardConfig.commonTextStyle,
                )),
              ],
            ),
          ),

          // ✅ Separator
          Container(
            width: screenWidth * BottomCardConfig.separatorWidthFactor,
            height: screenHeight * BottomCardConfig.separatorHeightFactor,
            color: BottomCardConfig.separatorColor,
          ),

          // ✅ Half Days (Fixed)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Half Days', textAlign: TextAlign.center, style: BottomCardConfig.commonTextStyle),
                Obx(() => Text(
                  '${controller.halfday.value} Days',
                  textAlign: TextAlign.center,
                  style: BottomCardConfig.commonTextStyle,
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
