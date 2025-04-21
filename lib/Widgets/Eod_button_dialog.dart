import 'package:flutter/material.dart';
import 'package:flutter_quill_delta_from_html/parser/html_to_delta.dart';
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
        return;
      }

      final today = DateTime.now();
      final tasks = await TaskService.fetchTaskList(empId, startDate: today, endDate: today);
      print("📋 Tasks fetched for $empId on $today:\n$tasks");



      final todayEOD = tasks.firstWhere(
            (task) => task['eod_id'] != null && task['eod_id'].toString().isNotEmpty,
        orElse: () => null,
      );

      if (todayEOD != null) {
        _eodId = todayEOD['eod_id'].toString();
        _eodResponse = todayEOD['bodDesc'];
        if (_eodResponse != null && _eodResponse!.isNotEmpty) {
          // Convert HTML to Delta using the HtmlToDelta converter
          final delta = HtmlToDelta().convert(_eodResponse!, transformTableAsEmbed: false);
          _quillController.document = Document.fromDelta(delta); // Set the Delta to the QuillController
        }
        _taskTitleController.text = todayEOD['eod'] ?? '';
        // Show 'eod' in title field

      }
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
    return SafeArea(child: Scaffold(
      appBar: CustomAppBar(title: 'What have you done today'),
      resizeToAvoidBottomInset: true,
      body:Container(
        margin: EdgeInsets.only(left: 12,right: 12),

        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomQuillEditor(
                          controller: _quillController,
                          taskTitleController: _taskTitleController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : PrimaryButton(
          onPressed: handleApiCall,
          text: _eodId != null ? "Update EOD" : "Submit EOD",
        ),
      ),
    )) ;
  }
}
