import 'package:employe_manage/Screens/welcom_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Widgets/otp_text_feild.dart';
import '/Configuration/config_file.dart';
import 'package:employe_manage/Configuration/style.dart';



class OtpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;



    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body:Stack(children: [Padding(
      padding: EdgeInsets.only(top: screenHeight * 0.02),
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text(
              'Enter the verification code sent to',
              style: fontStyles.headingStyle
            ),
            SizedBox(height: 8),
            Text(
              '9311289522',
              style: fontStyles.headingStyle,
            ),
            SizedBox(height: 8),
            Text(
              'Enter your number to get started',
              style: fontStyles.subTextStyle
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) => OtpTextField()),
            ),

            SizedBox(height: 20,),
            MainButton(initialtext: 'Resend Code'),


          ],)

          ),
        ),
        Positioned(
          bottom: 20, // Adjust spacing from the bottom
          left: 10,
          right: 10,
          child: MainButton(initialtext: 'Continue',onPressed: (){
            Get.to(() => welcomepage(title: 'welcome'));
          },),
        ),

    ]
      )
      // Continue Button

    );
  }
}
