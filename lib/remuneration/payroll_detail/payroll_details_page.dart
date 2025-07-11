import 'package:coreHrx_employeeapp/Widgets/App_bar.dart';
import 'package:coreHrx_employeeapp/Widgets/primary_button.dart';
import 'package:coreHrx_employeeapp/remuneration/model/payroll_model.dart';
import 'package:flutter/material.dart';

class PayrollDetailPage extends StatelessWidget {
  final PayrollItem item;

  const PayrollDetailPage({Key? key, required this.item}) : super(key: key);

  Widget _buildRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black)),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Salary Details",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTopCard(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Working Time",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                          width: 8), // thodi space text aur line ke beech
                      Expanded(
                        child: Divider(color: Colors.grey.shade200),
                      ),
                    ],
                  ),
                  _buildRow("Hours Worked", item.hoursWorked),
                  _buildRow("Working Days", item.workingDays),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        "Time off",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                          width: 8), // thodi space text aur line ke beech
                      Expanded(
                        child: Divider(color: Colors.grey.shade200),
                      ),
                    ],
                  ),
                  _buildRow("Paid Holidays", item.paidHolidays),
                  _buildRow("Absent Days", "-"),
                  _buildRow("Sick Leave Days", "-"),
                  _buildRow("Casual Leave Days", "-"),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        "Earning amount",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                          width: 8), // thodi space text aur line ke beech
                      Expanded(
                        child: Divider(color: Colors.grey.shade200),
                      ),
                    ],
                  ),
                  _buildRow("Basic Salary", item.basicSalary),
                  _buildRow("DA + HRA + Other", item.hra),
                  _buildRow("Other Allowance", item.otherAllowance),
                  _buildRow("Gross Salary", item.grossSalary, bold: true),
                  _buildRow("EPF - Employment Part", item.epf),
                  _buildRow("ESI - Employment", item.esi),
                  _buildRow("Cost-to-Company", item.costToCompany, bold: true),
                  _buildRow("Total Earning", item.totalEarning, bold: true),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        "Deduction amount",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(
                          width: 8), // thodi space text aur line ke beech
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ],
                  ),
                  _buildRow("Professional Tax", item.professionalTax),
                  _buildRow("Total Deduction", item.totalDeduction, bold: true),
                  _buildRow("Net Salary (INR)", item.netSalary, bold: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              icon: Icon(
                Icons.download_outlined,
                color: Colors.white,
                size: 20,
              ),
              text: "Download Slip",
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTopCard() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(item.employeeName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 7,
                    ),
                  ),
                  Text(item.employmentStatus,
                      style: const TextStyle(color: Colors.red)),
                ],
              ),
              Text(item.position),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(item.amount,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(item.date),
          ],
        )
      ],
    );
  }
}
