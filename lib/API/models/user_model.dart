class UserModel {
  final String name;
  final String designation;
  final String emp_type;

  UserModel({required this.name, required this.designation, required this.emp_type});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? "Unknown",
      designation: json['designation'] ?? "Unknown",
      emp_type: json['emp_type'] ?? "Unknown",
    );
  }
}
