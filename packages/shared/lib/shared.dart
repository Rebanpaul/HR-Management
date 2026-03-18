/// Shared library for HRMS platform.
/// Contains data models and API client used by both frontend (Web) and mobile apps.
library shared;

// Models
export 'models/user_model.dart';
export 'models/employee_model.dart';
export 'models/attendance_model.dart';
export 'models/leave_request_model.dart';
export 'models/payslip_model.dart';

// API
export 'api/api_client.dart';
export 'api/api_endpoints.dart';
