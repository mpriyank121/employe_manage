import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

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
  double _position = 0.0;
  bool _isChecking = false;
  bool _isCheckedIn = false;
  int _elapsedSeconds = 0;
  Timer? _timer;
  String? empId; // Store employee ID

  @override
  void initState() {
    super.initState();
    _loadEmployeeId(); // Load emp_id when the widget initializes
  }

  Future<void> _loadEmployeeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      empId = prefs.getString("emp_id"); // Retrieve employee ID
    });
  }

  Future<void> _performCheckIn() async {
    if (empId == null) {
      print("Employee ID is missing. Cannot check-in.");
      return;
    }

    setState(() {
      _isChecking = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/checkIn.php'),
    );

    request.fields.addAll({
      'emp_id': empId ?? '',
      'latitude': '28.5582006',
      'longitude': '77.341035',
      'type': 'checkin'
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      if (mounted) {
        setState(() {
          _isCheckedIn = true;
          _elapsedSeconds = 0;
        });

        widget.onCheckIn();
        _startTimer();
      }
    } else {
      print('Check-in failed');
    }

    setState(() {
      _isChecking = false;
    });
  }

  Future<void> _performCheckOut() async {
    if (empId == null) {
      print("Employee ID is missing. Cannot check-out.");
      return;
    }

    setState(() {
      _isChecking = true;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://apis-stg.bookchor.com/webservices/bookchor.com/dashboard_apis/checkIn.php'),
    );

    request.fields.addAll({
      'emp_id': empId ?? '',
      'latitude': '28.5582006',
      'longitude': '77.341035',
      'type': 'checkout'
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      if (mounted) {
        print('Check-Out successful');
        _stopTimer();
        widget.onCheckOut();
      }
    } else {
      print('Check-Out failed');
    }

    setState(() {
      _isChecking = false;
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedSeconds++;
        });
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
                      await _performCheckOut();
                    } else {
                      await _performCheckIn();
                    }

                    setState(() {
                      _position = 0;
                    });
                  } else if (_position <= 10 && _isCheckedIn) {
                    await _performCheckOut();

                    setState(() {
                      _position = 0;
                    });
                  } else {
                    setState(() {
                      _position = 0;
                    });
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
