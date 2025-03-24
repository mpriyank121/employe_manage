import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Configuration/app_colors.dart';

class YearMonthSelector extends StatefulWidget {
  final int initialYear;
  final int initialMonth;
  final Function(int, int) onDateChanged;

  const YearMonthSelector({
    super.key,
    required this.initialYear,
    required this.initialMonth,
    required this.onDateChanged,
  });

  @override
  _YearMonthSelectorState createState() => _YearMonthSelectorState();
}

class _YearMonthSelectorState extends State<YearMonthSelector> {
  late int selectedYear;
  late int selectedMonth;

  final List<String> months = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear;
    selectedMonth = widget.initialMonth;
  }

  /// ✅ Change the month (updates year after 12 months)
  void changeMonth(int step) {
    setState(() {
      selectedMonth += step;

      if (selectedMonth < 1) {
        selectedMonth = 12;
        selectedYear--; // Move to previous year
      } else if (selectedMonth > 12) {
        selectedMonth = 1;
        selectedYear++; // Move to next year
      }
    });

    widget.onDateChanged(selectedYear, 0); // ✅ Always send 0 for month
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.85,
      height: MediaQuery.of(context).size.height * 0.07,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondary),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Left Arrow (Previous Month)
          IconButton(
            onPressed: () => changeMonth(-1),
            icon: SvgPicture.asset('assets/images/chevron-u.svg'),
          ),

          /// Year & Month Display
          Text(
            "${months[selectedMonth - 1]} $selectedYear", // Example: "Mar 2024"
            style: const TextStyle(
              color: Color(0xFFF25922),
              fontSize: 20,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
            ),
          ),

          /// Right Arrow (Next Month)
          IconButton(
            onPressed: () => changeMonth(1),
            icon: SvgPicture.asset('assets/images/chevron-up.svg'),
          ),
        ],
      ),
    );
  }
}
