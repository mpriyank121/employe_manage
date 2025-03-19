import 'package:flutter/material.dart';
import 'package:employe_manage/API/models/holiday_model.dart'; // ✅ Use one consistent import path everywhere
import 'CustomListTile.dart';
import 'Custom_date_icon.dart';

class HolidayList extends StatelessWidget {
  final List<Holiday> holidays;
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (phoneNumber == null) {
      return const Center(child: Text("📢 Phone number not found"));
    } else if (holidays.isEmpty) {
      return const Center(child: Text("📢 No holidays available"));
    }

    return ListView.builder(
      itemCount: holidays.length,
      itemBuilder: (context, index) {
        final holiday = holidays[index];

        return CustomListTile(
          item: {
            "title": holiday.holiday, // Holiday Name
            "subtitle": holiday.holiday_date, // Holiday Date
          },
          leading: HolidayDateIcon(holidayDate: holiday.holiday_date), // Optional icon
        );
      },
    );
  }
}
