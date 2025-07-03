import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'camera_preview_screen.dart';
import 'location_error_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class SlideCheckIn extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final bool isCheckedIn;
  final String? firstIn;
  final String? lastOut;
  final bool isEnabled;
  final bool showCam;
  final String text;

  const SlideCheckIn({
    Key? key,
    required this.screenWidth,
    required this.screenHeight,
    required this.isCheckedIn,
    required this.text,
    this.firstIn,
    this.lastOut,
    required this.isEnabled,
    required this.showCam,
  }) : super(key: key);

  @override
  _SlideCheckInState createState() => _SlideCheckInState();
}

class _SlideCheckInState extends State<SlideCheckIn> {

  double _position = 0.0;
  bool _isChecking = false;
  bool _isCheckedIn = false;
  bool _isCheckInDisabled = false;
  List<CameraDescription>? _cameras;

  @override
  void initState() {
  }







  Color _getBackgroundColor() {
    if (_isCheckInDisabled) return Colors.grey.shade300;
    if (!widget.isEnabled) return const Color(0xFFE0E0E0);
    return widget.text == 'Slide To CheckOut'
        ? const Color(0xFFFFCDD2)
        : const Color(0x193CAB88);
  }

  Color _getBorderColor() {
    if (_isCheckInDisabled || !widget.isEnabled) return Colors.grey;
    return widget.text == 'Slide To CheckOut'
        ? Colors.red
        : const Color(0xFF3CAB88);
  }

  Color _getButtonColor() {
    if (!widget.isEnabled) return Colors.grey;
    return widget.text == 'Slide To CheckOut'
        ? Colors.red
        : const Color(0xFF3CAB88);
  }

  String _getDisplayText() {
    if (_isCheckInDisabled) return 'Check-In Completed';
    return widget.text;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!widget.isEnabled || _isChecking) return;

    setState(() {
      _position += details.delta.dx;
      if (_position < 0) _position = 0;
      if (_position > widget.screenWidth * 0.75) {
        _position = widget.screenWidth * 0.75;
      }
    });
  }

  Future<void> _onDragEnd(DragEndDetails details) async {
    if (!widget.isEnabled || _isChecking) return;

    if (_position >= widget.screenWidth * 0.7) {
      setState(() => _position = widget.screenWidth * 0.75);

      try {
        setState(() => _isChecking = true);

        if (widget.text == 'Slide To CheckIn') {
          // await _handleCheckIn();
        } else if (widget.text == 'Slide To CheckOut') {
          // await _handleCheckOut();
        }
      } finally {
        setState(() {
          _isChecking = false;
          _position = 0;
        });
      }
    } else {
      setState(() => _position = 0);
    }
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
                color: _getBackgroundColor(),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: _getBorderColor(),
                  ),
                  borderRadius: BorderRadius.circular(81),
                ),
              ),
              child: Center(
                child: Text(
                  _getDisplayText(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            // Slide Button
            Positioned(
              left: _position + widget.screenWidth * 0.02,
              top: widget.screenHeight * 0.028,
              child: GestureDetector(
                onHorizontalDragUpdate: _onDragUpdate,
                onHorizontalDragEnd: _onDragEnd,
                child: Container(
                  width: widget.screenWidth * 0.12,
                  height: widget.screenHeight * 0.06,
                  decoration: ShapeDecoration(
                    color: _getButtonColor(),
                    shape: const OvalBorder(),
                  ),
                  child: _isChecking
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Icon(
                    Icons.arrow_forward,
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