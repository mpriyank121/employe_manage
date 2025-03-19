import 'package:flutter/material.dart';
import '../API/models/holiday_model.dart';

class HolidayCard extends StatelessWidget {
  final Holiday holiday;

  const HolidayCard({Key? key, required this.holiday}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.calendar_today),
        title: Text(holiday.holiday_date),
        subtitle: Text(holiday.holiday),
      ),
    );
  }
}
