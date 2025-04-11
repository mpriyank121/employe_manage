import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:employe_manage/Widgets/task_table.dart';
import '../API/Controllers/task_controller.dart';
import '../Widgets/Bod_button_dialog.dart';
import '../Widgets/Eod_button_dialog.dart';

class TaskScreen extends StatelessWidget {
  final TaskController controller = Get.find<TaskController>();

  Future<void> _selectDateRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(Duration(days: 365)),
      lastDate: now.add(Duration(days: 365)),
      initialDateRange: controller.startDate.value != null && controller.endDate.value != null
          ? DateTimeRange(
        start: controller.startDate.value!,
        end: controller.endDate.value!,
      )
          : null,
    );

    if (picked != null) {
      controller.updateDateRange(picked.start, picked.end);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          showBackButton: false,
          title: "My Tasks"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),

              // 🔹 Date Range Picker
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
                        controller.startDate.value != null && controller.endDate.value != null
                            ? " ${DateFormat('yyyy-MM-dd').format(controller.startDate.value!)} - ${DateFormat('yyyy-MM-dd').format(controller.endDate.value!)}"
                            : "Select Date Range",
                        style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),


                      ),
                    ),
                  ),
                  PrimaryButton(
                    widthFactor: 0.35,
                    heightFactor: 0.055,
                    onPressed: controller.resetDateRange,
                    text: "Reset",
                  )
                ],
              ),
              const SizedBox(height: 10),

              // 🔹 Task List
              Expanded(
                child: TaskListWidget(
                  key: ValueKey('${controller.startDate.value}_${controller.endDate.value}_${controller.empId.value}'),
                  employeeId: controller.empId.value,
                  startDate: controller.startDate.value,
                  endDate: controller.endDate.value,
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
                      Navigator.push(context, MaterialPageRoute(builder: (_) => Bodbuttondialog()));
                    },
                    text: "ADD BOD",
                  ),
                  PrimaryButton(
                    widthFactor: 0.42,
                    heightFactor: 0.05,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => Eodbuttondialog()));
                    },
                    text: "ADD EOD",
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
