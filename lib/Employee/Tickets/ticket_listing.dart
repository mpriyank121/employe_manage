import 'package:flutter/material.dart';
import 'package:coreHrx_employeeapp/Widgets/App_bar.dart';
import 'package:coreHrx_employeeapp/Widgets/primary_button.dart';
import 'package:coreHrx_employeeapp/Employee/Tickets/Widgets/Ticket_List_Widget.dart';

class TicketListingPage extends StatelessWidget {
  const TicketListingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: CustomAppBar(
        centerTitle: false,
        title: "Ticket List",
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        trailing: PrimaryButton(
          heightFactor: 0.04,
          onPressed: null, // Disabled
          widthFactor: 0.3,
          text: 'Add Ticket',
        ),
      ),
      body: const Center(child: Text('No tickets found')), // Always empty
    ));
  }
}
