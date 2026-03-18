class AttendanceModel {
  final String id;
  final DateTime punchIn;
  final DateTime? punchOut;
  final double? punchInLat;
  final double? punchInLng;
  final double? punchOutLat;
  final double? punchOutLng;
  final String status;
  final String? notes;
  final String employeeId;
  final String tenantId;

  AttendanceModel({
    required this.id,
    required this.punchIn,
    this.punchOut,
    this.punchInLat,
    this.punchInLng,
    this.punchOutLat,
    this.punchOutLng,
    required this.status,
    this.notes,
    required this.employeeId,
    required this.tenantId,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as String,
      punchIn: DateTime.parse(json['punchIn'] as String),
      punchOut: json['punchOut'] != null
          ? DateTime.parse(json['punchOut'] as String)
          : null,
      punchInLat: (json['punchInLat'] as num?)?.toDouble(),
      punchInLng: (json['punchInLng'] as num?)?.toDouble(),
      punchOutLat: (json['punchOutLat'] as num?)?.toDouble(),
      punchOutLng: (json['punchOutLng'] as num?)?.toDouble(),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      employeeId: json['employeeId'] as String,
      tenantId: json['tenantId'] as String,
    );
  }

  /// Whether the employee is currently punched in (no punch-out yet)
  bool get isPunchedIn => punchOut == null;

  /// Duration worked (or duration since punch-in if still active)
  Duration get workedDuration {
    final end = punchOut ?? DateTime.now();
    return end.difference(punchIn);
  }

  /// Formatted worked hours (e.g., "8h 30m")
  String get workedHoursFormatted {
    final d = workedDuration;
    return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
  }
}
