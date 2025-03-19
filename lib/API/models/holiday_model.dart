class EmployeeInfo {
  final List<Holiday> holidays;
  final List<Employee> presentEmployees;
  final List<Employee> absentEmployees;
  final List<Employee> halfday;
  final List<Employee> week_off;

  EmployeeInfo({
    required this.holidays,
    required this.presentEmployees,
    required this.absentEmployees,
    required this.halfday,
    required this.week_off,
  });

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeInfo(
      holidays: (json['holidays'] as List?)?.map((e) => Holiday.fromJson(e)).toList() ?? [],
      halfday: (json['halfday'] as List?)?.map((e) => Employee.fromJson(e)).toList() ?? [],
      presentEmployees: (json['present_employees'] as List?)?.map((e) => Employee.fromJson(e)).toList() ?? [],
      absentEmployees: (json['absent_employees'] as List?)?.map((e) => Employee.fromJson(e)).toList() ?? [],
      week_off: (json['week_off'] as List?)?.map((e) => Employee.fromJson(e)).toList() ?? [],

    );
  }
}

class Holiday {
  final String holiday_date;
  final String holiday;

  Holiday({required this.holiday_date, required this.holiday});

  factory Holiday.fromJson(Map<String, dynamic> json) {
    print("Parsing holiday: $json"); // 🔍 Debug: Print each holiday item

    return Holiday(
      holiday_date: json['holiday_date'] ?? 'Unknown Date',
      holiday: json['holiday'] ?? 'No Reason Provided',

    );
  }
}

class Employee {
  final String presnt;
  final String absent;
  final String halfday;
  final String week_off;

  Employee({required this.presnt, required this.absent, required this.halfday,required this.week_off});

  factory Employee.fromJson(Map<String, dynamic> json) {
    print("Parsing attendence: $json"); // 🔍 Debug: Print each holiday item

    return Employee(
      presnt: json['present'] ?? 'N/A',
      absent: json['absent'] ?? 'N/A',
      halfday: json['halfday'] ?? 'N/A',
      week_off: json['week_off'] ?? "N/A",
    );
  }
}
