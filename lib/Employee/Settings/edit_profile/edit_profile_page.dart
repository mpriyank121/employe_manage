import 'package:coreHrx_employeeapp/Employee/Settings/edit_profile/controller/edit_profile_controller.dart';
import 'package:coreHrx_employeeapp/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:coreHrx_employeeapp/Widgets/App_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class EditProfilePage extends StatelessWidget {
  final controller = Get.put(EditProfileController());

  EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Edit Employee Details',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfilePictureSection(),
            const SizedBox(height: 24),
            _buildFormSection(),
            const SizedBox(height: 32),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Center(
      child: Column(
        children: [
          Obx(() => CircleAvatar(
                radius: 50,
                backgroundImage: controller.profileImagePath.isNotEmpty
                    ? FileImage(File(controller.profileImagePath.value))
                    : const AssetImage('assets/default_profile.png')
                        as ImageProvider,
              )),
          const SizedBox(height: 8),
          TextButton(
            onPressed: controller.pickImage,
            child: const Text(
              'Profile Picture',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Full Name'),
        _buildTextField(controller.nameController),
        _buildSectionTitle('Position'),
        _buildTextField(controller.positionController),
        _buildSectionTitle('Employment Status'),
        _buildDropdown(
          controller: controller.employmentStatusController,
          items: ['Full Time', 'Part Time', 'Contract', 'Freelance'],
        ),
        _buildSectionTitle('Department'),
        _buildTextField(controller.departmentController),
        _buildSectionTitle('Gender'),
        _buildDropdown(
          controller: controller.genderController,
          items: ['Male', 'Female', 'Other'],
        ),
        _buildSectionTitle('Date of Birth'),
        _buildDateField(controller.dobController),
        _buildSectionTitle('Phone Number'),
        _buildTextField(
          controller.phoneController,
          keyboardType: TextInputType.phone,
        ),
        _buildSectionTitle('Email'),
        _buildTextField(
          controller.emailController,
          keyboardType: TextInputType.emailAddress,
        ),
        _buildSectionTitle('Employee Identification Type'),
        _buildDropdown(
          controller: controller.idTypeController,
          items: ['Passport', 'Driver License', 'National ID'],
        ),
        _buildSectionTitle('Employee Identification Document'),
        Obx(() => _buildUploadButton(
              text: controller.documentPath.isNotEmpty
                  ? 'Document Selected'
                  : 'Upload',
              onPressed: controller.pickDocument,
            )),
        _buildSectionTitle('Start Date of Employment'),
        _buildDateField(controller.startDateController),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          controller.text = DateFormat('MMMM d, y').format(picked);
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget _buildDropdown({
    required TextEditingController controller,
    required List<String> items,
  }) {
    return DropdownButtonFormField<String>(
      value: controller.text.isNotEmpty ? controller.text : items.first,
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        controller.text = newValue!;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget _buildUploadButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(text),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: PrimaryButton(
            text: "Cancel",
            buttonColor:
                Colors.orange.withOpacity(0.1), // Custom color for cancel
            textColor: Colors.deepOrange,
            onPressed: () => Get.back(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: PrimaryButton(
            text: "Save",
            onPressed: () {
              if (controller.validateForm()) {
                controller.saveProfile();
                Get.back();
              }
            },
          ),
        ),
      ],
    );
  }
}
