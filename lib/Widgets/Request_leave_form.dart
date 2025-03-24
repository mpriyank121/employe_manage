import 'package:employe_manage/Configuration/style.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Leave_container.dart'; // Import LeaveContainer

class RequestLeavePage extends StatefulWidget {
  @override
  _RequestLeavePageState createState() => _RequestLeavePageState();
}
class _RequestLeavePageState extends State<RequestLeavePage> {
  String? leaveType = "Casual";
  DateTime? fromDate;
  DateTime? toDate;
  final TextEditingController aboutController = TextEditingController();
  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),     // Disable all future dates
    );
    if (picked != null && picked != initialDate) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
        } else {
          toDate = picked;
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Request Leave",
      ),
      body:SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Leave Type',style: fontStyles.headingStyle, ),
            // Leave Type Dropdown
            LeaveContainer(
              child: DropdownButtonFormField<String>(
                value: leaveType,
                items: ["Casual", "Sick", "Annual"].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    leaveType = value;
                  });
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            // From Date Picker
            Text('From',style: fontStyles.headingStyle, ),
            GestureDetector(
              onTap: () => _selectDate(context, true),
              child: LeaveContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      fromDate == null
                          ? "Select Date"
                          : DateFormat("MMMM dd, yyyy").format(fromDate!),
                      style: TextStyle(color: Colors.black54),
                    ),
                    Icon(Icons.calendar_today, color: Colors.black54),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            // To Date Picker
            Text('To',style: fontStyles.headingStyle, ),
            GestureDetector(
              onTap: () => _selectDate(context, false),
              child: LeaveContainer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      toDate == null
                          ? "Select Date"
                          : DateFormat("MMMM dd, yyyy").format(toDate!),
                      style: TextStyle(color: Colors.black54),
                    ),
                    Icon(Icons.calendar_today, color: Colors.black54),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            // About Text Field
            Text('About',style: fontStyles.headingStyle, ),
            LeaveContainer(
              child: TextFormField(
                controller: aboutController,
                decoration: InputDecoration(
                  hintText: "Add a note",
                  border: InputBorder.none,
                ),
                maxLines: 3,
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: PrimaryButton(text: "Delete"),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                    onPressed: () {},
                    text: "Request",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),)
    );
  }
}
