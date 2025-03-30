import 'package:flutter/material.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:employe_manage/Widgets/task_table.dart';
import '../Widgets/Bod_button_dialog.dart';
import 'package:intl/intl.dart';
import '../Widgets/Eod_button_dialog.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDateRange(BuildContext context) async {
    DateTime now = DateTime.now();
    DateTime firstDate = now.subtract(const Duration(days: 365));
    DateTime lastDate = now.add(const Duration(days: 365));

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: (_startDate != null && _endDate != null)
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(title: "My Tasks"),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10),

            // Date Range Picker Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _selectDateRange(context),
                  child: Text(
                    _startDate != null && _endDate != null
                        ? "📅 ${DateFormat('dd MMM yyyy').format(_startDate!)} - ${DateFormat('dd MMM yyyy').format(_endDate!)}"
                        : "Select Date Range",
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            // Task List with Date Filter
            Container(
              height: screenHeight * 0.6,
              child: TaskListWidget(
                employeeId: '229',
                startDate: _startDate,
                endDate: _endDate,
              ),
            ),

            Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryButton(
                  widthFactor: 0.4,
                  heightFactor: 0.05,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Bodbuttondialog()),
                    );
                  },
                  text: "ADD BOD",
                ),
                PrimaryButton(
                  widthFactor: 0.4,
                  heightFactor: 0.05,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Eodbuttondialog()),
                    );
                  },
                  text: "ADD EOD",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
