import 'package:coreHrx_employeeapp/Employee/Holidays/model/holiday_model.dart';
import 'package:flutter/material.dart';

class HolidayList extends StatelessWidget {
  final List<Holiday> holidays;
  final bool isLoading;

  const HolidayList({
    Key? key,
    required this.holidays,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Center(child: CircularProgressIndicator());
    if (holidays.isEmpty) return Center(child: Text('No holidays found.'));

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: holidays.length,
      itemBuilder: (context, index) {
        final holiday = holidays[index];
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/holiday_cal.png",
                height: 35,
                width: 30,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      holiday.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text('${holiday.date} • ${holiday.weekday}',
                        style: TextStyle(color: Colors.grey[700])),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
