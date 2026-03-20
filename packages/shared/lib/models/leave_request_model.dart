class LeaveRequestModel {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String leaveType;
  final String status; // PENDING, APPROVED, REJECTED
  final String employeeId;
  final String? employeeName;
  final String? employeeCode;
  final String? departmentName;
  final String tenantId;
  final DateTime createdAt;

  LeaveRequestModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.leaveType,
    required this.status,
    required this.employeeId,
    this.employeeName,
    this.employeeCode,
    this.departmentName,
    required this.tenantId,
    required this.createdAt,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    String? empName;
    String? empCode;
    String? deptName;

    if (json['employee'] != null) {
      final emp = json['employee'] as Map<String, dynamic>;
      empName = '${emp['firstName']} ${emp['lastName']}';
      empCode = emp['employeeCode'] as String?;
      final dept = emp['department'] as Map<String, dynamic>?;
      deptName = dept?['name'] as String?;
    }

    return LeaveRequestModel(
      id: json['id'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      reason: json['reason'] as String,
      leaveType: json['leaveType'] as String? ?? 'CASUAL',
      status: json['status'] as String,
      employeeId: json['employeeId'] as String,
      employeeName: empName,
      employeeCode: empCode,
      departmentName: deptName,
      tenantId: json['tenantId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Number of days for this leave
  int get totalDays => endDate.difference(startDate).inDays + 1;

  bool get isPending => status == 'PENDING';
  bool get isApproved => status == 'APPROVED';
  bool get isRejected => status == 'REJECTED';
}
