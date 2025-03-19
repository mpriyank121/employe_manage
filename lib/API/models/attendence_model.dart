class AttendanceData {
  final int present;
  final int absent;
  final int halfday;
  final int week_off;

  AttendanceData({required this.present, required this.absent, required this.halfday,required this.week_off});

  /// Factory method to create an instance from JSON
  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      present: int.tryParse(json['present'].toString()) ?? 0,  // ✅ Convert to int safely
      absent: int.tryParse(json['absent'].toString()) ?? 0,  // ✅ Convert to int safely
      halfday: int.tryParse(json['halfday'].toString()) ?? 0,
      week_off: int.tryParse(json['week_off'].toString()) ?? 0,
    );
  }
}
