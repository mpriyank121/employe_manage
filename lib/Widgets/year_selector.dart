import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Configuration/app_colors.dart';

class YearSelector extends StatefulWidget {

  final int initialYear;
  final Function(int) onYearChanged;

  const YearSelector({
    super.key,
    required this.initialYear,
    required this.onYearChanged,
  });

  @override
  _YearSelectorState createState() => _YearSelectorState();
}

class _YearSelectorState extends State<YearSelector> {
  late int selectedYear;


  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialYear;
  }

  void changeYear(int step) {
    setState(() {
      selectedYear += step;
    });
    widget.onYearChanged(selectedYear);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.85,
      height: MediaQuery.of(context).size.height * 0.06,

      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondary),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => changeYear(-1),
            icon: SvgPicture.asset('assets/images/chevron-u.svg'),
          ),
          Text(
            "$selectedYear",
            style: TextStyle(
              color: Color(0xFFF25922),
              fontSize: 22,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,


            ), // ✅ Use heading style from config
          ),
          IconButton(
            onPressed: () => changeYear(1),
            icon: SvgPicture.asset('assets/images/chevron-up.svg'),
          ),
        ],
      ),
    );
  }
}
