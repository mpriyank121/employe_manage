import 'package:employe_manage/Widgets/CustomListTile.dart';
import 'package:flutter/material.dart';
import '../API/Services/ticket_list_service.dart';

class TicketListWidget extends StatefulWidget {
  final String empId;
  final int limit;
  final int page;

  const TicketListWidget({
    Key? key,
    required this.empId,
    this.limit = 10,
    this.page = 1,
  }) : super(key: key);

  @override
  _TicketListWidgetState createState() => _TicketListWidgetState();
}

class _TicketListWidgetState extends State<TicketListWidget> {
  List<dynamic> tickets = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadTickets();
  }

  Future<void> loadTickets() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      List<dynamic> fetchedTickets = await fetchTickets(
        empId: widget.empId,
        limit: widget.limit,
        page: widget.page,
      );

      setState(() {
        tickets = fetchedTickets;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text("Error: $errorMessage", style: TextStyle(color: Colors.red)),
      );
    }

    if (tickets.isEmpty) {
      return Center(child: Text("No tickets found"));
    }

    return ListView.builder(
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        var ticket = tickets[index];

        return CustomListTile(
          heightFactor: 0.2,
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTicketDetail("Title", ticket['ticket_title']),
              _buildTicketDetail("Category", ticket['ticket_cat']),
              _buildTicketDetail("Assigned By", ticket['assigned_by']),
              _buildTicketDetail("Assigned To", ticket['assigned_to']),
              _buildTicketDetail("Priority", ticket['priority']),
              _buildTicketDetail("Date", ticket['date_added']),
              _buildTicketDetail("Status", ticket['status'] ?? 'Pending'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTicketDetail(String title, String? value) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: "$title: ", style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value ?? "N/A"),
        ],
      ),
    );
  }
}
