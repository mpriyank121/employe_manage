import 'package:employe_manage/Screens/ticket_listing.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/Widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../API/Services/apply_ticket_service.dart';
import '../API/Services/get_department_service.dart';
import '../API/Services/ticket_category_service.dart';
import '../Widgets/Custom_quill_editor.dart';

class TicketForm extends StatefulWidget {
  @override
  _TicketFormState createState() => _TicketFormState();
}

class _TicketFormState extends State<TicketForm> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String priority = 'High';
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
  List<Map<String, String>> departments = [];
  List<Map<String, String>> employees = [];
  List<Map<String, String>> categories = [];
  List<Map<String, String>> subcategories = [];
  bool isLoadingDepartments = true;
  bool isLoadingEmployees = false;
  bool isLoadingCategories = true;
  bool isLoadingSubCategories = false;

  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final QuillController _quillController = QuillController.basic();

  @override
  void initState() {
    super.initState();
    fetchDepartments();
    fetchTicketCategories();
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

    List<Map<String, String>> employeeData = await getEmployeesByDepartment(selectedDepartments);
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

    List<Map<String, String>> fetchedSubCategories = await getSubCategoriesByCategory(selectedCategory);

    setState(() {
      subcategories = fetchedSubCategories;
      selectedSubCategory = [];
      isLoadingSubCategories = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Create Ticket",
          centerTitle: false,
          trailing: PrimaryButton(
              heightFactor: 0.04,
              onPressed: (){
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => TicketScreen()));
    },
        widthFactor: 0.3,
        text: 'Show Listing'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 70.0),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Ticket Title *'),
                      onChanged: (value) => setState(() => title = value),
                      validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Priority'),
                      value: selectedPriority,
                      items: priorityMap.keys.map((String priorityLabel) {
                        return DropdownMenuItem(
                          value: priorityLabel,
                          child: Text(priorityLabel),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPriority = value!;
                        });
                      },
                    ),

                    isLoadingDepartments
                        ? Center(child: CircularProgressIndicator())
                        : MultiSelectDialogField(
                      items: departments
                          .map((dept) => MultiSelectItem(dept['id']!, dept['department']!))
                          .toList(),
                      title: Text('Departments'),
                      selectedItemsTextStyle: TextStyle(color: Colors.blue),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      buttonText: Text('Departments'),
                      onConfirm: (values) async {
                        setState(() {
                          selectedDepartments = List<String>.from(values);
                          employees = [];
                        });
                        await fetchEmployees();
                      },
                      initialValue: selectedDepartments,
                    ),
                    SizedBox(height: 10),
                    isLoadingEmployees
                        ? Center(child: CircularProgressIndicator())
                        : employees.isEmpty
                        ? Text("No employees found for the selected department.", style: TextStyle(color: Colors.red))
                        : MultiSelectDialogField(
                      items: employees.map((emp) => MultiSelectItem(emp['empid']!, emp['name']!)).toList(),
                      title: Text('Employees'),
                      selectedItemsTextStyle: TextStyle(color: Colors.blue),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      buttonText: Text('Employees'),
                      onConfirm: (values) {
                        setState(() {
                          selectedEmployees = values.map((e) => e.toString()).toList();
                        });

                        print("Selected Employees: $selectedEmployees"); // ✅ Debugging Output
                      },
                      initialValue: selectedEmployees,
                    ),


                    isLoadingCategories
                        ? Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Ticket Categories'),
                      value: selectedCategory.isEmpty ? null : selectedCategory.first,
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
                    if (selectedCategory.isNotEmpty && selectedCategory.first == '1')
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Order ID'),
                        onChanged: (value) {
                          setState(() {
                            orderId = value;
                          });
                        },
                        initialValue: orderId, // ✅ Ensures persistence
                      ),
                    if (selectedCategory.isNotEmpty && selectedCategory.first == '3')
                      TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Select Date',
                          suffixIcon: Icon(Icons.calendar_today),
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
                              attendanceDate = "${pickedDate.toLocal()}".split(' ')[0]; // ✅ Format date properly
                              _dateController.text = attendanceDate!; // ✅ Update text field
                            });
                          }
                        },
                      ),
                    isLoadingSubCategories
                        ? Center(child: CircularProgressIndicator())
                        : subcategories.isEmpty
                        ? Container()
                        : DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Ticket Subcategories'),
                      value: selectedSubCategory.isEmpty ? null : selectedSubCategory.first,
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
                    SizedBox(height: 10),
                    CustomQuillEditor(
                      controller: _quillController,
                      taskTitleController: _taskTitleController,
                      showTaskFields: false,
                      showDescriptionField: false,
                    ),
                    SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 16,
            right: 16,
            child:  PrimaryButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  String description = _quillController.document.toPlainText().trim();

                  await applyTicket(
                    empId: '229',
                    departments: selectedDepartments,
                    employeeOptions: selectedEmployees, // ✅ Correct Key Format
                    priority: priorityMap[selectedPriority] ?? '',
                    ticketTitle: title,
                    description: description,
                    ticketCat: selectedCategory.isNotEmpty ? selectedCategory.first : '',
                    ticketSubCat: selectedSubCategory.isNotEmpty ? selectedSubCategory.first : '',
                    orderId: orderId.isNotEmpty ? orderId : '',  // ✅ Fixed: Uses the correct `orderId`
                    attendanceDate: attendanceDate ?? '',       // ✅ Fixed: Uses `attendanceDate` safely
                    startDate: '',
                  );
                }

                print("Selected Employees: $selectedEmployees"); // ✅ Debugging Output

              },
              text: "Submit",

            ),

          ),
        ],
      ),
    );
  }
}
