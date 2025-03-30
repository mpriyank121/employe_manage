import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart 'as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import '../API/Services/BOD_service.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart'; // ✅ Required for toolbar & media support


class Bodbuttondialog extends StatefulWidget {
  @override
  _BodbuttondialogState createState() => _BodbuttondialogState();
}

class _BodbuttondialogState extends State<Bodbuttondialog> {
  final TextEditingController _taskTitleController = TextEditingController();
  final quill.QuillController _quillController = quill.QuillController.basic(); // ✅ Correct initialization

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
        setState(() {
          _bodResponse = "✅ BOD already submitted for today!\nBOD ID: $bodId";
        });
        Get.snackbar(
          "Info", "BOD already submitted!",
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
    String description = jsonEncode(_quillController.document.toDelta().toJson());

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
      String? response = await ApiBodService.sendData(
        taskTitle: taskTitle,
        description: description,
      );

      if (response != null) {
        Get.snackbar(
          "Success", "BOD Submitted!",
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
      appBar: AppBar(title: const Text("Submit BOD")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_bodResponse != null)
              Text(
                _bodResponse!,
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              )
            else ...[
              TextField(
                controller: _taskTitleController,
                decoration: const InputDecoration(labelText: "Task Title"),
              ),
              const SizedBox(height: 10),
              const Text("Description"),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: quill.QuillEditor.basic(
                    controller: _quillController,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: handleApiCall,
                child: const Text("Submit BOD"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
