import 'package:employe_manage/Configuration/app_spacing.dart';
import 'package:employe_manage/Screens/ticket_listing.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/Ticket_form_custom_container.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API/Services/apply_ticket_service.dart';
import '../API/Services/get_department_service.dart';
import '../API/Services/ticket_category_service.dart';
import '../Configuration/style.dart';
import '../Widgets/Custom_multi_select_dialog.dart';
import '../Widgets/Custom_quill_editor.dart';
import '../Widgets/Leave_container.dart';

class TicketForm extends StatefulWidget {
  @override
  _TicketFormState createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {


  final _formKey = GlobalKey<FormState>();
  String title = '';
  String priority = ' High';
  List<String> selectedDepartments = [];
  List<String> selectedEmployees = [];
  String description = '';
  List<String> selectedCategory = [];
  List<String> selectedSubCategory = [];
  String orderId = '';
  String? attendanceDate;

  final Map<String, String> priorityMap = {
    'High': '1',
    'Medium': '2',
    'Low': '3',
  };

// Default selected priority
  String selectedPriority = 'High';
  String selectedTicket = 'Order Related';
  List<Map<String, String>> departments = [];
  List<Map<String, String>> employees = [];
  List<Map<String, String>> categories = [];
  List<Map<String, String>> subcategories = [];
  bool isLoadingDepartments = true;
  bool isLoadingEmployees = false;
  bool isLoadingCategories = true;
  bool isLoadingSubCategories = false;
  String empId = '';

  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final QuillController _quillController = QuillController.basic();

  @override
  void initState() {
    super.initState();
    fetchDepartments();
    fetchTicketCategories();
    loadEmpId();
  }

  Future<void> fetchDepartments() async {
    List<Map<String, String>> departmentData = await getDepartment();
    setState(() {
      departments = departmentData;
      isLoadingDepartments = false;
    });
  }

  Future<void> fetchTicketCategories() async {
    List<Map<String, String>> fetchedCategories = await getTicketCategories();
    setState(() {
      categories = fetchedCategories;
      isLoadingCategories = false;
    });
  }

  Future<void> loadEmpId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      empId = prefs.getString('emp_id') ?? '';
    });

    print("👤 Logged-in Emp ID: $empId");
  }

  Future<void> fetchEmployees() async {
    if (selectedDepartments.isEmpty) {
      setState(() {
        employees = [];
      });
      return;
    }
    setState(() {
      isLoadingEmployees = true;
    });

    List<Map<String, String>> employeeData = await getEmployeesByDepartment(
        selectedDepartments);
    setState(() {
      employees = employeeData;
      isLoadingEmployees = false;
    });
  }

  Future<void> fetchSubCategories() async {
    if (selectedCategory.isEmpty) {
      setState(() {
        subcategories = [];
        selectedSubCategory = [];
      });
      return;
    }

    setState(() {
      isLoadingSubCategories = true;
    });

    List<Map<String,
        String>> fetchedSubCategories = await getSubCategoriesByCategory(
        selectedCategory);

    setState(() {
      subcategories = fetchedSubCategories;
      selectedSubCategory = [];
      isLoadingSubCategories = false;
    });
  }

  Widget buildLabeledField(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: fontStyles.headingStyle),
        LeaveContainer(child: field),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Create Ticket",
          centerTitle: true,
        ),
        body:Container(
          margin: const EdgeInsets.only(left: 12,right: 12),

          child:Stack(

          children: [
            // Scrollable form content
            AppSpacing.small(context),
            Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              // Leave space for button
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSpacing.small(context),

                      Text('Title', style: fontStyles.headingStyle),
                      AppSpacing.small(context),
                      LeaveContainer(
                        child: TextFormField(

                          decoration: const InputDecoration(

                            hintText: 'Enter Title',

                            border: InputBorder.none,
                          ),
                          onChanged: (value) => setState(() => title = value),
                          validator: (value) =>
                          value!.isEmpty
                              ? 'Enter a title'
                              : null,
                        ),
                      ),
                      AppSpacing.small(context),
                      Text('Priority', style: fontStyles.headingStyle),
                      AppSpacing.small(context),
                      LeaveContainer(
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(border: InputBorder
                              .none),
                          value: selectedPriority,
                          items: priorityMap.keys.map((priorityLabel) {
                            return DropdownMenuItem(
                              value: priorityLabel,
                              child: Text(priorityLabel),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => selectedPriority = value!);
                          },
                        ),
                      ),
                      AppSpacing.small(context),

                      Text('Departments', style: fontStyles.headingStyle),
                      AppSpacing.small(context),
                      isLoadingDepartments
                          ? const Center(child: CircularProgressIndicator())
                          :  CustomMultiSelectDialogField(
                          items: departments.map((dept) => {
                            'value': dept['id']!,
                            'label': dept['department']!,
                          }).toList(),
                          initialValue: selectedDepartments,
                          title: "Departments",
                          buttonText: "Departments",
                          onConfirm: (values) async {
                            setState(() {
                              selectedDepartments = values;
                              employees = [];
                            });
                            await fetchEmployees();
                          },
                        ),



                      AppSpacing.small(context),

                      if (isLoadingEmployees)
                        const Center(child: CircularProgressIndicator())
                      else
                        if (employees.isNotEmpty)
                          CustomMultiSelectDialogField(
                              items: employees
                                  .map((emp) => {
                                'value': emp['empid']!,
                                'label': emp['name']!,
                              })
                                  .toList(),
                              initialValue: selectedEmployees,
                              title: "Employees",
                              buttonText: "Employees",
                              onConfirm: (values) {
                                setState(() {
                                  selectedEmployees = values.map((e) => e.toString()).toList();
                                });
                              },
                            ),
                      AppSpacing.small(context),

                      if (!isLoadingCategories)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ticket Categories',
                                style: fontStyles.headingStyle),
                            AppSpacing.small(context),

                            LeaveContainer(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  hintText: "Ticket Categories",
                                    border: InputBorder.none),
                                items: categories.map((category) {
                                  return DropdownMenuItem<String>(
                                    value: category['id']!,
                                    child: Text(category['category_name']!),
                                  );
                                }).toList(),
                                onChanged: (value) async {
                                  setState(() {
                                    selectedCategory = [value!];
                                    subcategories = [];
                                    selectedSubCategory = [];
                                  });
                                  await fetchSubCategories();
                                },
                              ),
                            ),
                          ],
                        ),
                      AppSpacing.small(context),


                      if (selectedCategory.isNotEmpty &&
                          selectedCategory.first == '1')
                        LeaveContainer(
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: 'Order ID',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) =>
                                setState(() => orderId = value),
                            initialValue: orderId,
                          ),
                        ),
                      AppSpacing.small(context),

                      if (selectedCategory.isNotEmpty &&
                          selectedCategory.first == '3')
                        AppSpacing.small(context),
                        LeaveContainer(
                          child: TextFormField(
                            controller: _dateController,

                            decoration: const InputDecoration(
                              hintText: 'Select Date',
                              suffixIcon: Icon(Icons.calendar_today),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 0),

                            ),

                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  attendanceDate =
                                  "${pickedDate.toLocal()}".split(' ')[0];
                                  _dateController.text = attendanceDate!;
                                });
                              }
                            },
                          ),
                        ),
                      AppSpacing.small(context),

                      if (isLoadingSubCategories)
                        const Center(child: CircularProgressIndicator())
                      else
                        if (subcategories.isNotEmpty)
                          AppSpacing.small(context),
                          LeaveContainer(

                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                hintText: 'Ticket Subcategories',
                                border: InputBorder.none,
                              ),
                              value: selectedSubCategory.isEmpty
                                  ? null
                                  : selectedSubCategory.first,
                              items: subcategories.map((subcat) {
                                return DropdownMenuItem<String>(
                                  value: subcat['id']!,
                                  child: Text(subcat['category_name']!),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSubCategory = [value!];
                                });
                              },
                            ),
                          ),

                      AppSpacing.small(context),

                      CustomQuillEditor(
                        controller: _quillController,
                        taskTitleController: _taskTitleController,
                        showTaskFields: false,
                        showDescriptionField: false,
                      ),

                      AppSpacing.small(context), // Extra space at bottom
                    ],
                  ),
                ),
              ),
            ),
            AppSpacing.small(context),

            // Fixed submit button
            Positioned(
              bottom: 0,
              left: 16,
              right: 16,
              child: PrimaryButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String description = _quillController.document.toPlainText()
                        .trim();

                    await applyTicket(
                      empId: empId,
                      departments: selectedDepartments,
                      employeeOptions: selectedEmployees,
                      priority: priorityMap[selectedPriority] ?? '',
                      ticketTitle: title,
                      description: description,
                      ticketCat: selectedCategory.isNotEmpty ? selectedCategory
                          .first : '',
                      ticketSubCat: selectedSubCategory.isNotEmpty
                          ? selectedSubCategory.first
                          : '',
                      orderId: orderId.isNotEmpty ? orderId : '',
                      attendanceDate: attendanceDate ?? '',
                      startDate: '',
                    );

                    Navigator.pop(context, true);
                  }
                },
                text: "Submit",
              ),
            ),
          ],
        ),)

      ),
    );
  }
}
