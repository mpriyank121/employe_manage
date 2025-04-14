import 'package:employe_manage/Configuration/style.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:intl/intl.dart';
import '../API/Controllers/leave_controller.dart';
import '../API/Services/leave_type_service.dart';
import 'Leave_container.dart';

class RequestLeavePage extends StatefulWidget {
  @override
  _RequestLeavePageState createState() => _RequestLeavePageState();
}

class _RequestLeavePageState extends State<RequestLeavePage> {
  DateTime? fromDate;
  DateTime? toDate;
  final TextEditingController aboutController = TextEditingController();
  String? selectedLeaveType;
  List<Map<String, String>> leaveTypes = [];
  bool isLoading = false;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  final LeaveController leaveController = Get.put(LeaveController());


  @override
  void initState() {
    super.initState();
    loadLeaveTypes();
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime now = DateTime.now();

    final DateTime initialDate = isFromDate
        ? (fromDate ?? now)
        : (toDate ?? fromDate ?? now);

    final DateTime firstDate = isFromDate
        ? DateTime(2000)
        : (fromDate ?? DateTime(2000));

    final DateTime lastDate = isFromDate
        ? (toDate ?? DateTime(2101)) // ⬅️ Prevent selecting fromDate after toDate
        : DateTime(2101);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      setState(() {
        if (isFromDate) {
          fromDate = picked;
          // Reset toDate if it's before the new fromDate
          if (toDate != null && toDate!.isBefore(fromDate!)) {
            toDate = null;
          }
        } else {
          toDate = picked;
          // Reset fromDate if it's after the new toDate
          if (fromDate != null && fromDate!.isAfter(toDate!)) {
            fromDate = null;
          }
        }
      });
    }
  }

  void loadLeaveTypes() async {
    try {
      List<Map<String, String>> types = await LeaveTypeService.fetchLeaveTypes();
      setState(() {
        leaveTypes = types;
      });
    } catch (e) {
      print("🔴 Error fetching leave types: $e");
    }
  }

  Future<void> applyLeave() async {
    if (selectedLeaveType == null || fromDate == null || toDate == null || aboutController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    bool success = await LeaveTypeService.applyLeave(
      type: "apply_leave",
      leaveId: selectedLeaveType!,
      startDate: DateFormat('yyyy-MM-dd').format(fromDate!),
      endDate: DateFormat('yyyy-MM-dd').format(toDate!),
      note: aboutController.text,
    );

    setState(() => isLoading = false);

    if (success) {
      Get.snackbar(
        "Success",
        "Leave Applied Successfully!",
        snackPosition: SnackPosition.BOTTOM,
      );
      leaveController.fetchLeaveData(selectedYear,selectedMonth,false);

      // ✅ Navigate back
      Navigator.pop(context);
    } else {
      Get.snackbar(
        "Error",
        "Failed to Apply Leave",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: "Request Leave",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Leave Type', style: fontStyles.headingStyle),
                    LeaveContainer(
                      height: screenHeight * 0.07,
                      child: DropdownButtonFormField<String>(
                        value: selectedLeaveType,
                        items: leaveTypes.map((type) {
                          return DropdownMenuItem(

                            value: type['id'],
                            child: Text(type['name']!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLeaveType = value;
                          });
                          print("🛑 Selected Leave Type ID: $value");
                        },
                        decoration: InputDecoration(
                          hintText: " Select Leave Type",
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('From', style: fontStyles.headingStyle),
                    GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: LeaveContainer(
                        height: screenHeight * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              fromDate == null
                                  ? " Select Date"
                                  : DateFormat("MMMM dd, yyyy").format(fromDate!),
                              style: TextStyle(color: Colors.black54),
                            ),
                            Icon(Icons.calendar_today, color: Colors.black54),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('To', style: fontStyles.headingStyle),
                    GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: LeaveContainer(
                        height: screenHeight * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              toDate == null
                                  ? " Select Date"
                                  : DateFormat("MMMM dd, yyyy").format(toDate!),
                              style: TextStyle(color: Colors.black54),
                            ),
                            Icon(Icons.calendar_today, color: Colors.black54),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text('Reason', style: fontStyles.headingStyle),
                    LeaveContainer(
                      height: screenHeight * 0.2,
                      child: TextFormField(
                        controller: aboutController,
                        decoration: InputDecoration(
                          hintText: " Enter Reason",
                          border: InputBorder.none,
                        ),
                        maxLines: 7,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    onPressed: isLoading ? null : applyLeave,
                    text: isLoading ? "Applying..." : "Apply",
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
