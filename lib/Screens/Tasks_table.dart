import 'package:flutter/material.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:employe_manage/Widgets/task_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/Bod_button_dialog.dart';
import '../Widgets/Eod_button_dialog.dart';
import 'package:intl/intl.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  String? empId;
  DateTime? _startDate;
  DateTime? _endDate;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllTasksByDefault();
    _loadEmpId();
  }

  void _fetchAllTasksByDefault() {
    final now = DateTime.now();
    final fifteenDaysAgo = now.subtract(Duration(days: 15));

    setState(() {
      _startDate = fifteenDaysAgo;
      _endDate = now;
    });
  }

  Future<void> _loadEmpId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      empId = prefs.getString('emp_id');
      isLoading = false;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "My Tasks"),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
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
                  child: TextButton(
                    onPressed: () => _selectDateRange(context),
                    child: Text(
                      _startDate != null && _endDate != null
                          ? "📅 ${DateFormat('yyyy-MM-dd').format(_startDate!)} - ${DateFormat('yyyy-MM-dd').format(_endDate!)}"
                          : "Select Date Range",
                    ),
                  ),
                ),
                PrimaryButton(
                  widthFactor: 0.35,
                  heightFactor: 0.055,
                  onPressed: _fetchAllTasksByDefault,
                  text: "Reset",
                )
              ],
            ),
            const SizedBox(height: 10),

            // 🔹 Task List with Shared Pref empId
            Expanded(
              child: TaskListWidget(
                key: ValueKey('${_startDate}_${_endDate}_${empId}'),
                employeeId: empId ?? '',
                startDate: _startDate,
                endDate: _endDate,
              ),
            ),

            // 🔹 BOD & EOD Buttons
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
