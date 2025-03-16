class UserModel {
  final String name;
  final String designation;

  UserModel({required this.name, required this.designation});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? "Unknown",
      designation: json['designation'] ?? "Unknown",
    );
  }
}
