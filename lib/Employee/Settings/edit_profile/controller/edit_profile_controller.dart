import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  // Form controllers
  final nameController = TextEditingController();
  final positionController = TextEditingController();
  final employmentStatusController = TextEditingController(text: 'Full Time');
  final departmentController = TextEditingController();
  final genderController = TextEditingController(text: 'Male');
  final dobController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final idTypeController = TextEditingController(text: 'Passport');
  final startDateController = TextEditingController();

  // File paths
  final profileImagePath = ''.obs;
  final documentPath = ''.obs;

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImagePath.value = pickedFile.path;
    }
  }

  Future<void> pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      documentPath.value = result.files.single.path!;
    }
  }

  bool validateForm() {
    if (nameController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter full name');
      return false;
    }
    if (emailController.text.isEmpty || !emailController.text.isEmail) {
      Get.snackbar('Error', 'Please enter valid email');
      return false;
    }
    return true;
  }

  void saveProfile() {
    // Implement your save logic here
    Get.snackbar('Success', 'Profile updated successfully');
  }

  @override
  void onClose() {
    nameController.dispose();
    positionController.dispose();
    employmentStatusController.dispose();
    departmentController.dispose();
    genderController.dispose();
    dobController.dispose();
    phoneController.dispose();
    emailController.dispose();
    idTypeController.dispose();
    startDateController.dispose();
    super.onClose();
  }
}
