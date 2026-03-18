class EmployeeModel {
  final String id;
  final String employeeCode;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? designation;
  final String? departmentId;
  final String? departmentName;
  final String? email;
  final String? role;
  final String tenantId;
  final DateTime createdAt;

  EmployeeModel({
    required this.id,
    required this.employeeCode,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.designation,
    this.departmentId,
    this.departmentName,
    this.email,
    this.role,
    required this.tenantId,
    required this.createdAt,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String,
      employeeCode: json['employeeCode'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String?,
      designation: json['designation'] as String?,
      departmentId: json['departmentId'] as String?,
      departmentName: json['department'] != null
          ? (json['department'] as Map<String, dynamic>)['name'] as String?
          : null,
      email: json['user'] != null
          ? (json['user'] as Map<String, dynamic>)['email'] as String?
          : null,
      role: json['user'] != null
          ? (json['user'] as Map<String, dynamic>)['role'] as String?
          : null,
      tenantId: json['tenantId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  String get fullName => '$firstName $lastName';
}
