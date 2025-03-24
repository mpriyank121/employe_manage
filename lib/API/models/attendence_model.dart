class AttendanceData {
  final int present;
  final int absent;
  final int halfday;
  final int week_off;
  final String first_in;  // New field
  final String last_out; // New field

  AttendanceData({
    required this.present,
    required this.absent,
    required this.halfday,
    required this.week_off,
    required this.first_in,  // ✅ Added field
    required this.last_out, // ✅ Added field
  });

  /// Factory method to create an instance from JSON
  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      present: int.tryParse(json['present'].toString()) ?? 0,
      absent: int.tryParse(json['absent'].toString()) ?? 0,
      halfday: int.tryParse(json['halfday'].toString()) ?? 0,
      week_off: int.tryParse(json['week_off'].toString()) ?? 0,
      first_in: json['last_in'] ?? "N/A", // ✅ Parse safely
      last_out: json['first_out'] ?? "N/A", // ✅ Parse safely
    );
  }
}
