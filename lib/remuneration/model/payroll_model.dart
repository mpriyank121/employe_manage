class PayrollItem {
  final String employeeName;
  final String position;
  final String employmentStatus;
  final String date;
  final String amount;
  final String time;
  final String hoursWorked;
  final String workingDays;
  final String paidHolidays;
  final String basicSalary;
  final String hra;
  final String otherAllowance;
  final String grossSalary;
  final String epf;
  final String esi;
  final String costToCompany;
  final String totalEarning;
  final String professionalTax;
  final String totalDeduction;
  final String netSalary;

  PayrollItem({
    required this.employeeName,
    required this.position,
    required this.employmentStatus,
    required this.date,
    required this.amount,
    required this.time,
    required this.hoursWorked,
    required this.workingDays,
    required this.paidHolidays,
    required this.basicSalary,
    required this.hra,
    required this.otherAllowance,
    required this.grossSalary,
    required this.epf,
    required this.esi,
    required this.costToCompany,
    required this.totalEarning,
    required this.professionalTax,
    required this.totalDeduction,
    required this.netSalary,
  });
}
