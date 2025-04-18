import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../API/Controllers/task_controller.dart';
import '../API/Services/BOD_service.dart';
import '../API/Services/Task_service.dart';
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
  String? _bodId; // 🔽 Store bodId fetched from TaskService

  @override
  void initState() {
    super.initState();
    checkBODStatus();
  }

  Future<void> checkBODStatus() async {
    setState(() => _isLoading = true);
    try {
      final empId = await ApiBodService.getEmployeeId();
      if (empId == null) {
        return;
      }

      final today = DateTime.now();
      final tasks = await TaskService.fetchTaskList(empId, startDate: today, endDate: today);

      final todayBOD = tasks.firstWhere(
            (task) => task['bod_id'] != null && task['bod_id'].toString().isNotEmpty,
        orElse: () => null,
      );

      if (todayBOD != null) {
        _bodId = todayBOD['bod_id'].toString();

        _taskTitleController.text = todayBOD['bod'] ?? '';
        _quillController.document = Document()..insert(0, todayBOD['bodDesc'] ?? '');

        }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> handleApiCall() async {
    if (_taskTitleController.text.trim().isEmpty) {
      Get.snackbar("Error", "Task title is required!", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await ApiBodService.sendData(
        taskTitle: _taskTitleController.text.trim(),
        description: _quillController.document.toPlainText().trim(),
        bodId: _bodId, // 🔽 If available, this triggers update
      );

      if (response != null) {
        Get.snackbar("Success", _bodId != null ? "BOD Updated!" : "BOD Submitted!",
            snackPosition: SnackPosition.BOTTOM,);
      }

      Navigator.pop(context);
    } catch (e) {
      } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'What are you doing today'),
      resizeToAvoidBottomInset: true,
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : PrimaryButton(
          onPressed: handleApiCall,

          text: _bodId != null ? "Update BOD" : "Submit BOD",
        ),
      ),
    );
  }
}
