import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/Custom_quill_editor.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import '../API/Services/Task_service.dart';
import '../API/Services/EOD_service.dart';

class Eodbuttondialog extends StatefulWidget {
  @override
  _EodbuttondialogState createState() => _EodbuttondialogState();
}

class _EodbuttondialogState extends State<Eodbuttondialog> {
  final TextEditingController _taskTitleController = TextEditingController();
  final QuillController _quillController = QuillController.basic();

  bool _isLoading = false;
  String? _eodResponse;
  String? _eodId;

  @override
  void initState() {
    super.initState();
    checkEODStatus();
  }

  Future<void> checkEODStatus() async {
    setState(() => _isLoading = true);
    try {
      final empId = await ApiEodService.getEmployeeId();
      if (empId == null) {
        setState(() => _eodResponse = "❌ Employee ID not found.");
        return;
      }

      final today = DateTime.now();
      final tasks = await TaskService.fetchTaskList(empId, startDate: today, endDate: today);

      final todayEOD = tasks.firstWhere(
            (task) => task['eod_id'] != null && task['eod_id'].toString().isNotEmpty,
        orElse: () => null,
      );

      if (todayEOD != null) {
        _eodId = todayEOD['eod_id'].toString();
        _taskTitleController.text = todayEOD['task_title'] ?? '';
        _quillController.document = Document()..insert(0, todayEOD['description'] ?? '');

        setState(() {
        });
      } else {
        setState(() => _eodResponse = "⚠️ No EOD submitted yet for today.");
      }
    } catch (e) {
      print("❌ Error checking EOD status: $e");
      setState(() => _eodResponse = "❌ Failed to fetch EOD status.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> handleApiCall() async {
    String taskTitle = _taskTitleController.text.trim();
    String description = _quillController.document.toPlainText().trim();

    if (taskTitle.isEmpty || description.isEmpty) {
      Get.snackbar("Error", "All fields are required!",
          snackPosition: SnackPosition.BOTTOM,);
      return;
    }

    setState(() => _isLoading = true);
    try {
      String? response = await ApiEodService.sendEodData(
        taskTitle: taskTitle,
        description: description,
        eodId: _eodId, // If present, will update
      );

      if (response != null) {
        Get.snackbar("Success", _eodId != null ? "EOD Updated!" : "EOD Submitted!",
            snackPosition: SnackPosition.BOTTOM,);

        Navigator.pop(context);
      }
    } catch (e) {
      print("🚨 Exception: $e");
      Get.snackbar("Error", "Something went wrong!", snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Submit EOD'),
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : PrimaryButton(
          onPressed: handleApiCall,
          text: _eodId != null ? "Update EOD" : "Submit EOD",
        ),
      ),
    );
  }
}
