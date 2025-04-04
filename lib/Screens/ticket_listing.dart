import 'package:employe_manage/Screens/ticket_form.dart';
import 'package:employe_manage/Widgets/App_bar.dart';
import 'package:employe_manage/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import '../Widgets/ticket_list_widget.dart';

class TicketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: false,
        title: "Ticket List",
      trailing: PrimaryButton(
          heightFactor: 0.04,
          onPressed: (){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TicketForm()));
      },
          widthFactor: 0.3,
          text: 'Add Ticket'),),
      body: TicketListWidget(empId: '229'), // Call the widget
    );
  }
}
