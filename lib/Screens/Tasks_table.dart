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

  @override
  void initState() {
    super.initState();
    _fetchAllTasksByDefault(); // ✅ Fetch all tasks on load
  }
  void _fetchAllTasksByDefault() {
    final now = DateTime.now();
    final fifteenDaysAgo = now.subtract(Duration(days: 15));

    setState(() {
      _startDate = fifteenDaysAgo;
      _endDate = now;
    });
  }


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

      // ✅ Debugging Selected Dates
      print("📅 Selected Start Date: $_startDate");
      print("📅 Selected End Date: $_endDate");
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
            const SizedBox(height: 10),

            // 🔹 Date Range Picker Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:TextButton(
                  onPressed: () => _selectDateRange(context),
                  child: Text(
                    _startDate != null && _endDate != null
                        ? "📅 ${DateFormat('yyyy-MM-dd').format(_startDate!)} - ${DateFormat('yyyy-MM-dd').format(_endDate!)}"
                        : "Select Date Range",
                  ),
                ) ,),
                PrimaryButton(
                  widthFactor: 0.35,
                  heightFactor: 0.055,
                  onPressed: _fetchAllTasksByDefault,
                  text: "Reset",// Reset date filter
                )

              ],
            ),
            const SizedBox(height: 10),
            // 🔹 Task List with Date Filter (Expanded to avoid ParentDataWidget Error)
            Expanded(
              child: TaskListWidget(
                key: ValueKey(_startDate.toString() + _endDate.toString()), // ✅ Forces rebuild
                employeeId: '229',
                startDate: _startDate,
                endDate: _endDate,
              ),
            ),

            // 🔹 Add BOD & EOD Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PrimaryButton(
                  widthFactor: 0.42,
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
                  widthFactor: 0.42,
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
