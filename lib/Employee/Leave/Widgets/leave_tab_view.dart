import 'package:flutter/material.dart';

class LeaveTabView extends StatelessWidget {
  final double heightFactor;
  final int selectedYear;
  final int selectedMonth;
  final bool useCustomRange;

  const LeaveTabView({
    super.key,
    required this.heightFactor,
    required this.selectedYear,
    required this.selectedMonth,
    this.useCustomRange = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('No leave data available'),
    );
  }
}
