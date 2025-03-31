import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../API/Services/BOD_service.dart';
import 'Custom_quill_editor.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:flutter_quill/flutter_quill.dart';

class Bodbuttondialog extends StatefulWidget {
  @override
  _BodbuttondialogState createState() => _BodbuttondialogState();
}

class _BodbuttondialogState extends State<Bodbuttondialog> {
  final TextEditingController _taskTitleController = TextEditingController();
  final QuillController _quillController = QuillController.basic();
  bool _isLoading = false;
  String? _bodResponse;

  @override
  void initState() {
    super.initState();
    checkBODStatus();
  }

  Future<void> checkBODStatus() async {
    setState(() => _isLoading = true);
    try {
      String? bodId = await ApiBodService.fetchBodId();
      if (bodId != null) {
        setState(() => _bodResponse = "✅ BOD already submitted for today!\nBOD ID: $bodId");
        Get.snackbar("Info", "BOD already submitted!",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> handleApiCall() async {
    if (_taskTitleController.text.trim().isEmpty) {
      Get.snackbar("Error", "Task title is required!",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    setState(() => _isLoading = true);
    try {
      String? response = await ApiBodService.sendData(
        taskTitle: _taskTitleController.text.trim(),
        description: _quillController.document.toPlainText().trim(), // ✅ Fetch content
      );

      if (response != null) {
        Get.snackbar("Success", "BOD Submitted!",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Submit BOD'),
      resizeToAvoidBottomInset: true, // ✅ Prevents keyboard overflow
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    if (_bodResponse != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _bodResponse!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                      ),
                    Expanded(
                      child: CustomQuillEditor(
                        controller: _quillController,
                        taskTitleController: _taskTitleController,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : PrimaryButton(onPressed: handleApiCall, text: "Submit BOD"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
