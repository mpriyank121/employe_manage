import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../API/Services/Check_In_Service.dart';
import '../API/Services/employee_status_service.dart';
import '../API/Services/image_picker_service.dart';

class SlideCheckIn extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final bool isCheckedIn;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;
  final String? firstIn;  // ✅ From API response
  final String? lastOut;
  final bool isEnabled;// ✅ From API response

  const SlideCheckIn({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.isCheckedIn,
    required this.onCheckIn,
    required this.onCheckOut,
    this.firstIn,
    this.lastOut,
    required this.isEnabled,
  }) : super(key: key);

  @override
  _SlideCheckInState createState() => _SlideCheckInState();
}

class _SlideCheckInState extends State<SlideCheckIn> {
  final CheckInService _checkInService = CheckInService();
  final ImagePickerService _imagePickerService = ImagePickerService();

  double _position = 0.0;
  bool _isChecking = false;
  bool _isCheckedIn = false;
  bool _isCheckInDisabled = false;  // ✅ New flag to disable slider
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _loadCheckInState();
  }

  /// ✅ Fetches check-in status and updates the UI
  Future<void> _loadCheckInState() async {
    try {
      print("Fetching check-in status...");  // ✅ Debugging
      final CheckStatus checkStatus = CheckStatus();
      final response = await checkStatus.getCheckInStatus('229');

      if (response != null) {
        print("API Response: $response");  // ✅ Debugging API data

        setState(() {
          String? firstIn = response['checkinIn'];  // ✅ Correct key
          String? lastOut = response['checkinOut']; // ✅ Correct key

          _isCheckedIn = firstIn != null && lastOut == null; // ✅ Checked in but not checked out
          _isCheckInDisabled = firstIn != null && lastOut != null; // ✅ Disable check-in if both exist
        });

        print("Updated State -> isCheckedIn: $_isCheckedIn, isCheckInDisabled: $_isCheckInDisabled");
      } else {
        print("API returned null response.");
      }
    } catch (e) {
      debugPrint("Error fetching check-in status: $e");
    }
  }

  /// ✅ Handles Check-In Action
  Future<void> _handleCheckIn() async {
    if (_isCheckInDisabled) return;  // ✅ Prevent action if disabled
    File? image = await _imagePickerService.captureImage();
    if (image == null) return;

    setState(() {
      _isChecking = true;
      _selectedImage = image;
    });

    bool success = await _checkInService.performCheckIn(image);
    if (success) {
      print("✅ Check-in successful!");

      setState(() {
        _isCheckedIn = true;
      });

      widget.onCheckIn();
      await _loadCheckInState();  // ✅ Ensure state is refreshed
    }

    setState(() => _isChecking = false);
  }

  /// ✅ Handles Check-Out Action
  Future<void> _handleCheckOut() async {
    if (_isCheckInDisabled) return;  // ✅ Prevent action if disabled
    File? image = await _imagePickerService.captureImage();
    if (image == null) return;

    setState(() {
      _isChecking = true;
      _selectedImage = image;
    });

    bool success = await _checkInService.performCheckOut(image);
    if (success) {
      print("✅ Check-out successful!");

      setState(() {
        _isCheckedIn = false;
      });

      widget.onCheckOut();
      await _loadCheckInState();  // ✅ Ensure state is refreshed
    }

    setState(() => _isChecking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            // Background Container
            Container(
              width: widget.screenWidth * 0.9,
              height: widget.screenHeight * 0.08,
              margin: const EdgeInsets.only(top: 15),
              padding: EdgeInsets.symmetric(
                horizontal: widget.screenWidth * 0.05,
                vertical: widget.screenHeight * 0.02,
              ),
              decoration: ShapeDecoration(
                color: _isCheckInDisabled
                    ? Colors.grey.shade300
                    : (_isCheckedIn ? const Color(0x19FF0000) : const Color(0x193CAB88)),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: _isCheckInDisabled ||!widget.isEnabled?
                         Colors.grey
                        : (_isCheckedIn ? Colors.red : const Color(0xFF3CAB88)),
                  ),
                  borderRadius: BorderRadius.circular(81),
                ),
              ),
              child: Center(
                child: Text(
                  _isCheckInDisabled
                      ? 'Check-In Completed'
                      : (_isCheckedIn ? 'Slide to Check Out' : 'Slide to Check In'),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Slide Button (Only show if enabled)

              Positioned(
                left: _position + widget.screenWidth * 0.02,
                top: widget.screenHeight * 0.025,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    if (!widget.isEnabled) return;
                    setState(() {
                      _position += details.delta.dx;
                      if (_position < 0) _position = 0;
                      if (_position > widget.screenWidth * 0.75) {
                        _position = widget.screenWidth * 0.75;
                      }
                    });
                  },
                  onHorizontalDragEnd: (details) async {
                    if (!widget.isEnabled) return;
                    if (_position >= widget.screenWidth * 0.7) {
                      _position = widget.screenWidth * 0.75;
                      if (_isCheckedIn) {
                        await _handleCheckOut();
                      } else {
                        await _handleCheckIn();
                      }
                      setState(() => _position = 0);
                    } else {
                      setState(() => _position = 0);
                    }
                  },
                  child: Container(
                    width: widget.screenWidth * 0.12,
                    height: widget.screenHeight * 0.06,
                    decoration: ShapeDecoration(
                      color: widget.isEnabled? _isCheckedIn ? Colors.red : const Color(0xFF3CAB88):Colors.grey,
                      shape: const OvalBorder(),
                    ),
                    child: _isChecking
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Icon(
                      _isCheckedIn ? Icons.arrow_forward : Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
