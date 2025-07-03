import 'package:employe_manage/Configuration/app_spacing.dart';
import 'package:employe_manage/Widgets/Action_button.dart';
import 'package:employe_manage/Widgets/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'No_data_found.dart';
import '../Widgets/CustomListTile.dart';
import 'Reason_view_button.dart';

class PolicyListWidget extends StatelessWidget {
  final String empId;

  const PolicyListWidget({
    Key? key,
    required this.empId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No policies found'),
    );
  }
}
