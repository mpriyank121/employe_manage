import 'package:employe_manage/welcom_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';


class OtpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    Widget _otpTextField(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300], // Light grey background
            borderRadius: BorderRadius.circular(8), // Rounded corners
          ),
          child: SizedBox(
            width: 40, // Increased width for better spacing
            height: 50,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: TextStyle(fontSize: 18),
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none, // Remove default border
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.02),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(
                'Enter the verification code sent to',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 1.45,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '9311289522',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 1.45,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Enter your number to get started',
                style: TextStyle(
                  color: Color(0xFF949494),
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  height: 1.75,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) => _otpTextField(context)),
              ),
              SizedBox(height: 20),
              // Resend Code Button
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {


                    // Handle OTP resend
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Continue Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.deepOrange, // Background color
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: TextButton(
            onPressed: () {
              Get.to(() => welcomepage(title: 'welcome'));
              // Handle OTP submission
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(width: 8), // Space between text and icon
                SvgPicture.asset(
                  'assets/Arrow_Circle_Right.svg', // Ensure the image exists
                  height: 20,
                  width: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
