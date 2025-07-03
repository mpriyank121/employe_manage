import 'package:employe_manage/Screens/otp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Configuration/style.dart';
import '../widgets/app_bar.dart';
import '../widgets/primary_button.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _phoneController = TextEditingController();
  bool _hasCheckedVersion = false;

  @override
  Widget build(BuildContext context) {
    if (!_hasCheckedVersion) {
      WidgetsBinding.instance.addPostFrameCallback((_) {

      });
      _hasCheckedVersion = true;
    }

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(child: Scaffold(
      appBar: CustomAppBar(
        title: 'Bookchor',
        leading: IconButton(
          icon: SvgPicture.asset('assets/images/bc 3.svg'),
          onPressed: () {},
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('HR Management App', style: fontStyles.commonTextStyle),
            SizedBox(height: screenHeight * 0.02),

            Text('Enter Your Mobile Number', style: fontStyles.headingStyle),
            SizedBox(height: screenHeight * 0.015),

            Text(
              'Enter your mobile number to get started',
              style: fontStyles.commonTextStyle,
            ),
            SizedBox(height: screenHeight * 0.025),

            /// ✅ Phone Number Input Field
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                FilteringTextInputFormatter.digitsOnly, // Allow digits only
              ],
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                hintText: 'Enter your mobile number',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.03, top: screenHeight * 0.015),
                  child: Text('+91', style: fontStyles.headingStyle),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.025),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),

            Spacer(),

            /// ✅ Continue Button (disabled, no backend)
            PrimaryButton(
              text: 'Continue',
              icon: SvgPicture.asset('assets/images/Arrow_Circle_Right.svg'),
              onPressed:
              (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OtpPage(phone: '')),
                );
              }
              , // Disabled
            ),
          ],
        ),
      ),
    )) ;
  }
}
