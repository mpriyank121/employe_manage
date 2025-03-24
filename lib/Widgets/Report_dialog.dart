import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'App_bar.dart';
import 'Leave_container.dart';
import 'bottom_sheet_helper.dart';
import 'date_picker_field.dart';
import 'primary_button.dart';
import 'year_selector.dart';

class ReportAbsentPage extends StatefulWidget {
  @override
  _ReportAbsentPageState createState() => _ReportAbsentPageState();
}

class _ReportAbsentPageState extends State<ReportAbsentPage> {
  DateTime? fromDate;
  DateTime? toDate;
  String? workMode = "Present (WFH), Office";
  String clockIn = "10:00 AM";
  String clockOut = "07:00 PM";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Report Absent"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **📅 Year & Month Selector**
            Center(
              child: YearMonthSelector(
                initialYear: DateTime.now().year,
                initialMonth: DateTime.now().month,
                onDateChanged: (year, month) {
                  print("📆 Selected Date: $month/$year");
                },
              ),
            ),
            SizedBox(height: 10),

            /// **🔲 Work Mode Dropdown**
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Work Mode", style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  LeaveContainer(
                    child: DropdownButtonFormField<String>(
                      value: workMode,
                      items: ["Present (WFH), Office", "Sick", "Annual"].map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          workMode = value;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  /// **⏰ Clock In & Clock Out**
                  Row(
                    children: [
                      Expanded(
                        child: LeaveContainer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Clock In",
                              border: InputBorder.none,
                            ),
                            initialValue: clockIn,
                            readOnly: true,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: LeaveContainer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Clock Out",
                              border: InputBorder.none,
                            ),
                            initialValue: clockOut,
                            readOnly: true,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  /// **📆 Date Pickers (From & To)**
                  Row(
                    children: [
                      Expanded(
                        child: DatePickerField(
                          label: "From",
                          selectedDate: fromDate,
                          onTap: (context) => showDatePickerBottomSheet(
                            context,
                                (date, _, __) => setState(() => fromDate = date),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DatePickerField(
                          label: "To Date",
                          selectedDate: toDate,
                          onTap: (context) => showDatePickerBottomSheet(
                            context,
                                (date, _, __) {
                              setState(() => toDate = date); // ✅ Update selected date
                            },

                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  Text("Standard Hours: 9 Hours", style: TextStyle(color: Colors.green)),
                  SizedBox(height: 10),

                  /// **📝 Add a Note**
                  LeaveContainer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: "Add a note",
                        border: InputBorder.none,
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            /// **🚀 Action Buttons (Cancel & Report)**
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    heightFactor: 0.06,
                    buttonColor: Color(0x19F25822),
                    textColor: Colors.deepOrange,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    text: "Cancel",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: PrimaryButton(
                    heightFactor: 0.06,
                    onPressed: () {
                      print("📋 Report Absent for: From $fromDate To $toDate");
                    },
                    text: "Report",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
