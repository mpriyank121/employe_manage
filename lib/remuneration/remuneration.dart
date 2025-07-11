import 'package:coreHrx_employeeapp/Widgets/App_bar.dart';
import 'package:coreHrx_employeeapp/Widgets/year_selector.dart';
import 'package:coreHrx_employeeapp/remuneration/controller/payrolll_controller.dart';

import 'package:coreHrx_employeeapp/remuneration/payroll_detail/payroll_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RemunerationPage extends StatelessWidget {
  final controller = Get.put(PayrollController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Remuneration"),
      body: Column(
        children: [
          const SizedBox(height: 10),
          YearMonthSelector(
            initialYear: DateTime.now().year,
            initialMonth: DateTime.now().month,
            showMonth: false,
            onDateChanged: (year, _) {},
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() => ListView.separated(
                  itemCount: controller.payrollList.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade100),
                  itemBuilder: (context, index) {
                    final item = controller.payrollList[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0x1A4CAF50),
                        child: Icon(Icons.currency_rupee, color: Colors.black),
                      ),
                      title: Text('Payroll - ${item.amount}'),
                      subtitle: Text('Paid at ${item.time}, ${item.date}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Get.to(() => PayrollDetailPage(item: item));
                      },
                    );
                  },
                )),
          )
        ],
      ),
    );
  }
}
