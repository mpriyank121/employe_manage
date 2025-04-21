import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/Policy_List_Widget.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({Key? key}) : super(key: key);

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  String? empId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmpId();
  }

  Future<void> _loadEmpId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      empId = prefs.getString('emp_id');
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Policy List",
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : empId == null
            ? const Center(child: Text("No employee ID found."))
            : Padding(
          padding: const EdgeInsets.only(top: 10),
          child: PolicyListWidget(
            empId: empId!,
          ),
        ),
      ),
    );
  }
}
