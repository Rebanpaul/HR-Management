class UserModel {
  final String id;
  final String email;
  final String role;
  final String tenantId;
  final EmployeeInfo? employee;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    required this.tenantId,
    this.employee,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      tenantId: json['tenantId'] as String,
      employee: json['employee'] != null
          ? EmployeeInfo.fromJson(json['employee'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'role': role,
        'tenantId': tenantId,
        'employee': employee?.toJson(),
      };

  /// Check if the user has a specific role
  bool hasRole(String role) => this.role == role;

  /// Check if the user is at least a manager
  bool get isManager =>
      role == 'MANAGER' || role == 'HR_ADMIN' || role == 'SUPER_ADMIN';

  /// Check if the user is an admin
  bool get isAdmin => role == 'HR_ADMIN' || role == 'SUPER_ADMIN';

  /// Check if the user is a super admin
  bool get isSuperAdmin => role == 'SUPER_ADMIN';
}

class EmployeeInfo {
  final String id;
  final String employeeCode;
  final String firstName;
  final String lastName;

  EmployeeInfo({
    required this.id,
    required this.employeeCode,
    required this.firstName,
    required this.lastName,
  });

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeInfo(
      id: json['id'] as String,
      employeeCode: json['employeeCode'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'employeeCode': employeeCode,
        'firstName': firstName,
        'lastName': lastName,
      };

  String get fullName => '$firstName $lastName';
}

class AuthResponse {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}
