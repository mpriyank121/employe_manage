import 'package:employe_manage/Screens/ticket_form.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/ticket_list_widget.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
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
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: false,
        title: "Ticket List",
        trailing: PrimaryButton(
          heightFactor: 0.04,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TicketForm()),
            );
          },
          widthFactor: 0.3,
          text: 'Add Ticket',
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : empId == null
          ? Center(child: Text("❌ Employee ID not found"))
          : TicketListWidget(empId: empId!),
    );
  }
}
