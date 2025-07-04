
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Configuration/app_spacing.dart';
import '../../Configuration/style.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Request Leave'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.small(context),
            Text('Leave Type', style: fontStyles.headingStyle),
            LeaveContainer(
              child: DropdownButtonFormField<String>(
                value: selectedLeaveType,
                items: [],
                onChanged: null,
                decoration: const InputDecoration(
                  hintText: 'Select Leave Type',
                ),
              ),
            ),
            AppSpacing.small(context),
            Text('From Date', style: fontStyles.headingStyle),
            LeaveContainer(
              child: TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Select From Date',
                ),
              ),
            ),
            AppSpacing.small(context),
            Text('To Date', style: fontStyles.headingStyle),
            LeaveContainer(
              child: TextFormField(
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Select To Date',
                ),
              ),
            ),
            AppSpacing.small(context),
            Text('About', style: fontStyles.headingStyle),
            LeaveContainer(
              child: TextFormField(
                controller: aboutController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter reason for leave',
                ),
              ),
            ),
            AppSpacing.small(context),
            PrimaryButton(
              onPressed: null, // Disabled
              text: 'Submit',
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
