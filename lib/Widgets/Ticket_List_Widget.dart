import 'package:employe_manage/Widgets/CustomListTile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API/Services/ticket_list_service.dart';
import 'No_data_found.dart';

class TicketListWidget extends StatefulWidget {
  final String empId;

  const TicketListWidget({
    Key? key,
    required this.empId,
  }) : super(key: key);

  @override
  TicketListWidgetState createState() => TicketListWidgetState();
}

class TicketListWidgetState extends State<TicketListWidget> {
  List<dynamic> tickets = [];
  bool isLoading = true;
  bool isLoadingMore = false;
  bool hasMore = true;
  int currentPage = 1;
  final int limit = 100;
  String? errorMessage;
  String? superuser;

  late ScrollController _scrollController;
  final GlobalKey<TicketListWidgetState> ticketListKey = GlobalKey<TicketListWidgetState>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    loadTickets(); // first load
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
  void refreshTickets() {
    ticketListKey.currentState?.loadTickets(); // 🔁 Trigger ticket reload
  }
  void _onScroll() {

    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      // if (!isLoadingMore && hasMore) {
    print("Scrolling...");
        _loadMoreTickets();

      // }
    }
  }

  Future<void> loadTickets({int page = 1}) async {
    if (page == 1) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int superUser = prefs.getInt('super_user') ?? 0;
      List<dynamic> fetchedTickets = await fetchTickets(
        empId: widget.empId,
        limit: limit,
        page: page,
        superUser: superUser, // Pass superUser to the API call
      );
      print("Fetching page: $page");

      setState(() {
        if (page == 1) {
          tickets = fetchedTickets;
        } else {
          tickets.addAll(fetchedTickets);
        }

        hasMore = fetchedTickets.length == limit;
        currentPage = page;
      });
    } catch (e) {
      if(page>1) return;
       {
        setState(() {
          errorMessage = e.toString();
        });
      }
    } finally {
      if (page == 1) {
        setState(() => isLoading = false);
      } else {
        setState(() => isLoadingMore = false);
      }
    }
  }

  Future<void> _loadMoreTickets() async {
    setState(() => isLoadingMore = true);
    await loadTickets(page: currentPage + 1);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return const NoDataWidget(
        message: "No tickets found",
        imagePath: "assets/images/Error_image.png", // your image path
      );
    }

    if (tickets.isEmpty) {
      return const Center(child: Text("No tickets found"));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: tickets.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == tickets.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }

        var ticket = tickets[index];

        return CustomListTile(

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
          TextSpan(text: "$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: value ?? "N/A"),
        ],
      ),
    );
  }
}
