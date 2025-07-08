import 'package:flutter/material.dart';

class HolidayList extends StatelessWidget {
  final List holidays;
  final bool isLoading;
  final String? phoneNumber;

  const HolidayList({
    Key? key,
    required this.holidays,
    required this.isLoading,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("No Holidays available"),
    );
  }
}
