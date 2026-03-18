class PayslipModel {
  final String id;
  final int month;
  final int year;
  final double basicSalary;
  final double deductions;
  final double netSalary;
  final String? pdfUrl;
  final String employeeId;
  final String? employeeName;
  final String? employeeCode;
  final String tenantId;

  PayslipModel({
    required this.id,
    required this.month,
    required this.year,
    required this.basicSalary,
    required this.deductions,
    required this.netSalary,
    this.pdfUrl,
    required this.employeeId,
    this.employeeName,
    this.employeeCode,
    required this.tenantId,
  });

  factory PayslipModel.fromJson(Map<String, dynamic> json) {
    String? empName;
    String? empCode;

    if (json['employee'] != null) {
      final emp = json['employee'] as Map<String, dynamic>;
      empName = '${emp['firstName']} ${emp['lastName']}';
      empCode = emp['employeeCode'] as String?;
    }

    return PayslipModel(
      id: json['id'] as String,
      month: json['month'] as int,
      year: json['year'] as int,
      basicSalary: (json['basicSalary'] as num).toDouble(),
      deductions: (json['deductions'] as num).toDouble(),
      netSalary: (json['netSalary'] as num).toDouble(),
      pdfUrl: json['pdfUrl'] as String?,
      employeeId: json['employeeId'] as String,
      employeeName: empName,
      employeeCode: empCode,
      tenantId: json['tenantId'] as String,
    );
  }

  /// Formatted month-year (e.g., "March 2026")
  String get periodFormatted {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[month - 1]} $year';
  }
}
