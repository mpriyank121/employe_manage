import 'package:coreHrx_employeeapp/Employee/request_leave/controller/request_leave_controller.dart';
import 'package:coreHrx_employeeapp/Widgets/App_bar.dart';
import 'package:coreHrx_employeeapp/Widgets/primary_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RequestLeave extends StatelessWidget {
  const RequestLeave({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RequestLeaveController());

    return Scaffold(
      appBar: CustomAppBar(
        title: "Request Leave",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Leave Type"),
            const SizedBox(height: 6),
            Obx(() => CustomDropdown(
                  value: controller.selectedLeaveType.value,
                  items: controller.leaveTypes,
                  onChanged: controller.setLeaveType,
                )),
            const SizedBox(height: 16),
            const Text("From"),
            const SizedBox(height: 6),
            Obx(() => CustomDateField(
                  date: controller.fromDate.value,
                  onDateSelected: controller.setFromDate,
                )),
            const SizedBox(height: 16),
            const Text("To"),
            const SizedBox(height: 6),
            Obx(() => CustomDateField(
                  date: controller.toDate.value,
                  onDateSelected: controller.setToDate,
                )),
            const SizedBox(height: 16),
            const Text("About"),
            const SizedBox(height: 6),
            TextField(
              controller: controller.aboutNote,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Add a note",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Attachments"),
            const SizedBox(height: 6),
            FileUploadTile(
              onFilePicked: controller.setAttachment,
              filePathObs: controller.attachmentPath,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      text: "Delete",
                      buttonColor: Colors.deepOrange.withOpacity(0.1),
                      textColor: Colors.deepOrange,
                      onPressed: () => Get.back(),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryButton(
                      text: "Save",
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String value;
  final List<String> items;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}

class CustomDateField extends StatelessWidget {
  final DateTime date;
  final void Function(DateTime) onDateSelected;

  const CustomDateField({
    super.key,
    required this.date,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat.yMMMMd().format(date)),
            const Icon(Icons.calendar_today_outlined, size: 18),
          ],
        ),
      ),
    );
  }
}

class FileUploadTile extends StatelessWidget {
  final void Function(String path) onFilePicked;
  final RxString filePathObs;

  const FileUploadTile({
    super.key,
    required this.onFilePicked,
    required this.filePathObs,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filePath = filePathObs.value;
      return GestureDetector(
        onTap: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null && result.files.single.path != null) {
            onFilePicked(result.files.single.path!);
          }
        },
        child: Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: filePath.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.upload_file_outlined, size: 28),
                    SizedBox(height: 6),
                    Text("Upload", style: TextStyle(color: Colors.grey)),
                  ],
                )
              : Text("File: ${filePath.split('/').last}"),
        ),
      );
    });
  }
}
