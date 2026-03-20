import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../../auth/providers/auth_provider.dart';

class TeamAttendanceState {
  final List<AttendanceModel> records;
  final bool isLoading;
  final String? error;
  final DateTime date;

  TeamAttendanceState({
    this.records = const [],
    this.isLoading = false,
    this.error,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  TeamAttendanceState copyWith({
    List<AttendanceModel>? records,
    bool? isLoading,
    String? error,
    DateTime? date,
  }) {
    return TeamAttendanceState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      date: date ?? this.date,
    );
  }
}

class TeamAttendanceNotifier extends StateNotifier<TeamAttendanceState> {
  final ApiClient _apiClient;

  TeamAttendanceNotifier(this._apiClient) : super(TeamAttendanceState()) {
    fetch();
  }

  Future<void> fetch({DateTime? date}) async {
    final target = date ?? state.date;
    state = state.copyWith(isLoading: true, error: null, date: target);

    try {
      final dateStr =
          "${target.year.toString().padLeft(4, '0')}-${target.month.toString().padLeft(2, '0')}-${target.day.toString().padLeft(2, '0')}";
      final res = await _apiClient.dio.get(
        ApiEndpoints.attendanceTeam,
        queryParameters: {'date': dateStr},
      );
      final list = (res.data as List)
          .cast<Map<String, dynamic>>()
          .map(AttendanceModel.fromJson)
          .toList();
      state = state.copyWith(records: list, isLoading: false);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load attendance.',
      );
    }
  }
}

final teamAttendanceProvider =
    StateNotifierProvider<TeamAttendanceNotifier, TeamAttendanceState>(
  (ref) => TeamAttendanceNotifier(ref.watch(apiClientProvider)),
);
