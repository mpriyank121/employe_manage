import 'dart:convert';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/Custom_quill_editor.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import '../API/Services/EOD_service.dart';
import 'package:delta_to_html/delta_to_html.dart';


class Eodbuttondialog extends StatefulWidget {
  @override
  _EodbuttondialogState createState() => _EodbuttondialogState();
}

class _EodbuttondialogState extends State<Eodbuttondialog> {
  final TextEditingController _taskTitleController = TextEditingController();
  final QuillController _quillController = QuillController.basic();

  bool _isLoading = false;
  String? _eodResponse;

  @override
  void initState() {
    super.initState();
    checkEODStatus();
  }

  Future<void> checkEODStatus() async {
    setState(() => _isLoading = true);
    try {
      String? eodId = await ApiEodService.fetchEodId();

      if (eodId != null) {
        setState(() {
          _eodResponse = "✅ EOD already submitted for today!\nEOD ID: $eodId";
        });
        Get.snackbar(
          "Info", "EOD already submitted!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print("🚨 API Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> handleApiCall() async {
    String taskTitle = _taskTitleController.text.trim();
    String description = DeltaToHTML.encodeJson(_quillController.document.toDelta().toJson());
    print("$description");

    if (taskTitle.isEmpty || description.isEmpty) {
      Get.snackbar(
        "Error", "All fields are required!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      String? response = await ApiEodService.sendEodData(
        taskTitle: taskTitle,
        description: description,
      );

      if (response != null) {
        Get.snackbar(
          "Success", "EOD Submitted!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Already", "Updated",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
                    if (_eodResponse != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _eodResponse!,
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
                  ],
                ),
              ),
            ),
          );
        },
      ),

      // 🔽 Bottom Navigation Bar with Primary Button 🔽
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),

        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : PrimaryButton(onPressed: handleApiCall, text: "Submit EOD"),
      ),
    );
  }

}
