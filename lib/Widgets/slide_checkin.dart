import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../API/Services/Check_In_Service.dart';
import '../API/Services/image_picker_service.dart';

class SlideCheckIn extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final bool isCheckedIn;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;

  const SlideCheckIn({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.isCheckedIn,
    required this.onCheckIn,
    required this.onCheckOut,
  }) : super(key: key);

  @override
  _SlideCheckInState createState() => _SlideCheckInState();

}

class _SlideCheckInState extends State<SlideCheckIn> {
  final CheckInService _checkInService = CheckInService();
  final ImagePickerService _imagePickerService = ImagePickerService(); // Use the new service


  double _position = 0.0;
  bool _isChecking = false;
  bool _isCheckedIn = false;
  int _elapsedSeconds = 0;
  File? _selectedImage;

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadCheckInState(); // ✅ Load saved check-in state on app start
  }
  Future<void> _loadCheckInState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCheckedIn = prefs.getBool('isCheckedIn') ?? false;
      if (_isCheckedIn) {
        _startTimer(); // Resume timer if checked in
      }
    });
  }
  Future<void> _saveCheckInState(bool isCheckedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCheckedIn', isCheckedIn);
  }
  Future<void> _handleCheckIn() async {
    File? image = await _imagePickerService.captureImage(); // Capture image using service
    if (image == null) return;
    setState(() {
      _isChecking = true;
      _selectedImage = image;
    });
    bool success = await _checkInService.performCheckIn(image);
    if (success) {
      setState(() {
        _isCheckedIn = true;
        _elapsedSeconds = 0;
      });
      widget.onCheckIn();
      await _saveCheckInState(true);
      _startTimer();
    }
    setState(() => _isChecking = false);
  }
  Future<void> _handleCheckOut() async {
    File? image = await _imagePickerService.captureImage(); // Capture image using service
    if (image == null) return;
    setState(() {
      _isChecking = true;
      _selectedImage = image;
    });
    bool success = await _checkInService.performCheckOut(image);
    if (success) {
      _stopTimer();
      widget.onCheckOut();
      await _saveCheckInState(false);
    }
    setState(() => _isChecking = false);
  }
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() => _elapsedSeconds++);
      }
    });
  }
  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isCheckedIn = false;
      _position = 0;
    });
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: widget.screenWidth * 0.9,
              height: widget.screenHeight * 0.08,
              margin: const EdgeInsets.only(top: 15),
              padding: EdgeInsets.symmetric(
                horizontal: widget.screenWidth * 0.05,
                vertical: widget.screenHeight * 0.02,
              ),
              decoration: ShapeDecoration(
                color: _isCheckedIn ? const Color(0x19FF0000) : const Color(0x193CAB88),
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: _isCheckedIn ? Colors.red : const Color(0xFF3CAB88)),
                  borderRadius: BorderRadius.circular(81),
                ),
              ),
              child: Center(
                child: Text(
                  _isCheckedIn ? 'Slide to Check Out' : 'Slide to Check In',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Positioned(
              left: _position + widget.screenWidth * 0.02,
              top: widget.screenHeight * 0.025,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _position += details.delta.dx;
                    if (_position < 0) _position = 0;
                    if (_position > widget.screenWidth * 0.75) {
                      _position = widget.screenWidth * 0.75;
                    }
                  });
                },
                onHorizontalDragEnd: (details) async {
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
                    color: _isCheckedIn ? Colors.red : const Color(0xFF3CAB88),
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
