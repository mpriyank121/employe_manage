
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Employee/Tasks/Widgets/Eod_button_dialog.dart';

import '../../Widgets/primary_button.dart';
import '../Configuration/app_spacing.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({Key? key}) : super(key: key);

  Future<void> _selectDateRange(BuildContext context) async {
    // No-op for static UI
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: CustomAppBar(
          showBackButton: false,
          title: "My Tasks"),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
        child: Column(
          children: [
            AppSpacing.small(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: null, // Disabled
                    child: Text(
                      "Select Date Range",
                      style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                    ),
                  ),
                ),
                PrimaryButton(
                  widthFactor: 0.35,
                  heightFactor: 0.055,
                  onPressed: null, // Disabled
                  text: "Reset",
                )
              ],
            ),
            AppSpacing.small(context),
            // Task List (empty)
            Expanded(
              child: Center(child: Text("No tasks available")),
            ),
          ],
        ),
      ),
    ));
  }
}
