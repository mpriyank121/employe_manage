import 'package:get/get.dart';
import 'package:coreHrx_employeeapp/remuneration/model/payroll_model.dart'; // ✅ Correct model import

class PayrollController extends GetxController {
  var year = 2024.obs;

  var payrollList = <PayrollItem>[
    PayrollItem(
      employeeName: 'William Brown',
      position: 'Tech - UI/UX Designer',
      employmentStatus: 'Full Time',
      date: '31 Dec, 2023',
      amount: '₹25,000',
      time: '09:40',
      hoursWorked: '230:00 hrs',
      workingDays: '31.00',
      paidHolidays: '04.00',
      basicSalary: '₹10,000.00',
      hra: '₹3,000.00',
      otherAllowance: '₹2,200.00',
      grossSalary: '₹25,200.00',
      epf: '-',
      esi: '-',
      costToCompany: '₹25,200.00',
      totalEarning: '₹25,200.00',
      professionalTax: '₹200.00',
      totalDeduction: '₹200.00',
      netSalary: '₹25,000.00',
    ),
    // Add more items as needed
  ].obs;

  void incrementYear() => year.value++;
  void decrementYear() => year.value--;
}
