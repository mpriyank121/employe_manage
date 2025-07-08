
import 'package:flutter/material.dart';

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
