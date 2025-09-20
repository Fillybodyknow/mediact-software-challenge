class LeaveRequestModel {
  final int shiftAssignmentId;
  final String reason;

  LeaveRequestModel({required this.shiftAssignmentId, required this.reason});

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      shiftAssignmentId: json['shift_assignment_id'],
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() => {
    'shift_assignment_id': shiftAssignmentId,
    'reason': reason,
  };
}

class LeaveRequestResponseModel {
  final String reason;
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final ApprovedBy approvedBy;

  LeaveRequestResponseModel({
    required this.reason,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.approvedBy,
  });

  factory LeaveRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestResponseModel(
      reason: json['reason'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
      approvedBy: ApprovedBy.fromJson(json['approved_by']),
    );
  }
}

class ApprovedBy {
  final int id;
  final bool Valid;

  ApprovedBy({required this.id, required this.Valid});

  factory ApprovedBy.fromJson(Map<String, dynamic> json) {
    return ApprovedBy(id: json['Int64'], Valid: json['Valid']);
  }
}
