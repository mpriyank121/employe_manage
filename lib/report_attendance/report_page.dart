import 'package:coreHrx_employeeapp/report_attendance/controller/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coreHrx_employeeapp/Widgets/app_bar.dart';
import 'package:coreHrx_employeeapp/Widgets/year_selector.dart';
import 'package:coreHrx_employeeapp/widgets/primary_button.dart';

class ReportPage extends StatelessWidget {
  ReportPage({Key? key}) : super(key: key);

  final ReportController controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Report Absent"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YearMonthSelector(
            initialYear: DateTime.now().year,
            initialMonth: DateTime.now().month,
            showMonth: false,
            onDateChanged: (year, _) {
              // Implement filter logic if needed
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              child: _buildAbsentReportWidget(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: "Cancel",
                    buttonColor: Colors.deepOrange.withOpacity(0.1),
                    textColor: Colors.deepOrange,
                    onPressed: () => Get.back(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: PrimaryButton(
                    text: "Request",
                    onPressed: () {
                      _submitReport();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsentReportWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(5)),
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Work Mode',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: controller.selectedWorkMode.value,
                    items: controller.workModes
                        .map((mode) => DropdownMenuItem(
                              value: mode,
                              child: Text(mode,
                                  style: const TextStyle(fontSize: 15)),
                            ))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        controller.setWorkMode(val);
                      }
                    },
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            const Text(
              'From Date    To Date',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    return GestureDetector(
                      onTap: () => controller.pickDate(context, true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.formatDate(controller.fromDate.value),
                              style: const TextStyle(fontSize: 15),
                            ),
                            const Icon(Icons.calendar_today, size: 20),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() {
                    return GestureDetector(
                      onTap: () => controller.pickDate(context, false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.formatDate(controller.toDate.value),
                              style: const TextStyle(fontSize: 15),
                            ),
                            const Icon(Icons.calendar_today, size: 20),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Clock In    Clock Out',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    return GestureDetector(
                      onTap: () => controller.pickTime(context, true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller
                                  .formatTimeOfDay(controller.clockIn.value),
                              style: const TextStyle(fontSize: 15),
                            ),
                            const Icon(Icons.access_time, size: 20),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() {
                    return GestureDetector(
                      onTap: () => controller.pickTime(context, false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller
                                  .formatTimeOfDay(controller.clockOut.value),
                              style: const TextStyle(fontSize: 15),
                            ),
                            const Icon(Icons.access_time, size: 20),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Standard Hours: 9 Hours',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Note:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() {
              // Use a TextEditingController so that text changes update properly:
              final textController =
                  TextEditingController(text: controller.note.value);
              // To avoid cursor jump, update text only if different:
              if (textController.text != controller.note.value) {
                textController.text = controller.note.value;
                textController.selection = TextSelection.fromPosition(
                  TextPosition(offset: textController.text.length),
                );
              }

              return Container(
                height: 75,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: textController,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your note here...',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: controller.setNote,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _submitReport() {
    print('Work Mode: ${controller.selectedWorkMode.value}');
    print('From Date: ${controller.formatDate(controller.fromDate.value)}');
    print('To Date: ${controller.formatDate(controller.toDate.value)}');
    print('Clock In: ${controller.formatTimeOfDay(controller.clockIn.value)}');
    print(
        'Clock Out: ${controller.formatTimeOfDay(controller.clockOut.value)}');
    print('Note: ${controller.note.value}');
    // TODO: Add your validation or API submission here
  }
}
