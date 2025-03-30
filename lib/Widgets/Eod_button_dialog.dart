import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../API/Services/EOD_service.dart'; // Assuming there's an EOD service

class Eodbuttondialog extends StatefulWidget {
  @override
  _EodbuttondialogState createState() => _EodbuttondialogState();
}

class _EodbuttondialogState extends State<Eodbuttondialog> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  String? _eodResponse;

  @override
  void initState() {
    super.initState();
    checkEODStatus();
  }

  // ✅ Check if EOD already exists
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

  // ✅ Handle API Call (Submit EOD)
  Future<void> handleApiCall() async {
    String taskTitle = _taskTitleController.text.trim();
    String description = _descriptionController.text.trim();

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
      appBar: AppBar(title: const Text("Submit EOD")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_eodResponse != null)
              Text(
                _eodResponse!,
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              )
            else ...[
              TextField(
                controller: _taskTitleController,
                decoration: const InputDecoration(labelText: "Task Summary"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "description"),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: handleApiCall,
                child: const Text("Submit EOD"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
