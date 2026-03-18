/// Centralized API endpoint constants.
/// Both frontend (Web) and mobile apps reference these endpoints.
class ApiEndpoints {
  // Base URL — override per environment
  static String baseUrl = 'http://localhost:3000/api';

  // Auth
  static String get login => '$baseUrl/auth/login';
  static String get register => '$baseUrl/auth/register';
  static String get refresh => '$baseUrl/auth/refresh';
  static String get logout => '$baseUrl/auth/logout';

  // Employees
  static String get employees => '$baseUrl/employees';
  static String get employeeMe => '$baseUrl/employees/me';
  static String employeeById(String id) => '$baseUrl/employees/$id';

  // Attendance
  static String get punchIn => '$baseUrl/attendance/punch-in';
  static String get punchOut => '$baseUrl/attendance/punch-out';
  static String get attendanceToday => '$baseUrl/attendance/today';
  static String get attendanceHistory => '$baseUrl/attendance/history';
  static String get attendanceTeam => '$baseUrl/attendance/team';

  // Leave Requests
  static String get leaveRequests => '$baseUrl/leave-requests';
  static String leaveRequestById(String id) => '$baseUrl/leave-requests/$id';

  // Payslips
  static String get payslips => '$baseUrl/payslips';
  static String get myPayslips => '$baseUrl/payslips/me';
  static String payslipById(String id) => '$baseUrl/payslips/$id';
}
