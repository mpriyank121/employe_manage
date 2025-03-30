class LeaveModel {
  final String leaveName;
  final String startDate;
  final String endDate;
  final String status;
  final String comment;
  final String resson;

  LeaveModel({
    required this.leaveName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.comment,
    required this.resson
  });

  // Factory constructor to create an object from JSON
  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      leaveName: json['leave_name'],
      startDate: json['leave_start_date'],
      endDate: json['leave_end_date'],
      status: json['status'],
      comment: json['comment'],
      resson: json['resson'],
    );
  }
}
