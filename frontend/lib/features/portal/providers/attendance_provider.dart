import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../../auth/providers/auth_provider.dart';

class AttendanceState {
  final AttendanceModel? todayAttendance;
  final bool isLoading;
  final String? error;
  final String? successMessage;

  const AttendanceState({
    this.todayAttendance,
    this.isLoading = false,
    this.error,
    this.successMessage,
  });

  bool get isPunchedIn => todayAttendance != null && todayAttendance!.isPunchedIn;

  AttendanceState copyWith({
    AttendanceModel? todayAttendance,
    bool? isLoading,
    String? error,
    String? successMessage,
    bool clearAttendance = false,
  }) {
    return AttendanceState(
      todayAttendance:
          clearAttendance ? null : (todayAttendance ?? this.todayAttendance),
      isLoading: isLoading ?? this.isLoading,
      error: error,
      successMessage: successMessage,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  final ApiClient _apiClient;

  AttendanceNotifier(this._apiClient) : super(const AttendanceState()) {
    // Attempt to load today's attendance, but don't crash if backend is down
    Future.microtask(() => fetchToday());
  }

  Future<void> fetchToday() async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.attendanceToday);
      if (response.data != null && response.data != '') {
        state = AttendanceState(
          todayAttendance: AttendanceModel.fromJson(response.data),
        );
      } else {
        state = const AttendanceState();
      }
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to fetch today's attendance.",
      );
    }
  }

  Future<void> punchIn() async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);
    try {
      final response = await _apiClient.dio.post(ApiEndpoints.punchIn);
      state = AttendanceState(
        todayAttendance: AttendanceModel.fromJson(response.data),
        successMessage: 'Punched in successfully.',
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to punch in.',
      );
    }
  }

  Future<void> punchOut() async {
    state = state.copyWith(isLoading: true, error: null, successMessage: null);
    try {
      final response = await _apiClient.dio.post(ApiEndpoints.punchOut);
      state = AttendanceState(
        todayAttendance: AttendanceModel.fromJson(response.data),
        successMessage: 'Punched out successfully.',
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to punch out.',
      );
    }
  }
}

final attendanceProvider =
    StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AttendanceNotifier(apiClient);
});
