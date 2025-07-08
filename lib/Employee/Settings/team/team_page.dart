import 'package:flutter/material.dart';
import 'package:coreHrx_employeeapp/Widgets/App_bar.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Top tabs: All Members, Supervisors
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Team',
          bottom: const TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'All Members'),
              Tab(text: 'Supervisors'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AllMembersSection(),
            SupervisorsSection(),
          ],
        ),
      ),
    );
  }
}

class AllMembersSection extends StatelessWidget {
  const AllMembersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildSectionHeader("Supervisor"),
        _buildTeamMember("William Brown", "Product Engineer"),
        _buildSectionHeader("Team"),
        _buildTeamMember("Elizabeth Turner", "Engineering Manager"),
        _buildTeamMember("Emma Brown", "HR Manager"),
        _buildTeamMember("Mia Rodriguez", "HR Assistant"),
        _buildTeamMember("Oliver Green", "HR Coordinator"),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String position) {
    return Column(
      children: [
        ListTile(
          title: Text(name),
          subtitle: Text(position),
          trailing: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.call, color: Colors.blue),
              SizedBox(width: 16),
              Icon(Icons.message, color: Colors.blue),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class SupervisorsSection extends StatelessWidget {
  const SupervisorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildSectionHeader("Current Supervisors"),
        _buildSupervisor("William Brown", "Product Engineer", isCurrent: true),
        _buildSectionHeader("History"),
        _buildSupervisor("William Brown", "Product Engineer",
            dateRange: "From: 12/04/2024 to 12/04/2024"),
        _buildSupervisor("Mia Rodriguez", "HR Assistant",
            dateRange: "From: 12/04/2024 to 12/04/2024"),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildSupervisor(String name, String position,
      {bool isCurrent = false, String dateRange = ""}) {
    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              if (isCurrent)
                const Icon(Icons.circle, color: Colors.blue, size: 12),
              if (isCurrent) const SizedBox(width: 8),
              Text(name),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(position),
              if (dateRange.isNotEmpty)
                Text(
                  dateRange,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
            ],
          ),
          trailing: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.call, color: Colors.blue),
              SizedBox(width: 16),
              Icon(Icons.message, color: Colors.blue),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
