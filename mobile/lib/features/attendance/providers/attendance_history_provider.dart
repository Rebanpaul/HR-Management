import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../../auth/providers/auth_provider.dart';

class AttendanceHistoryState {
  final List<AttendanceModel> records;
  final bool isLoading;
  final String? error;

  const AttendanceHistoryState({
    this.records = const [],
    this.isLoading = false,
    this.error,
  });

  AttendanceHistoryState copyWith({
    List<AttendanceModel>? records,
    bool? isLoading,
    String? error,
  }) {
    return AttendanceHistoryState(
      records: records ?? this.records,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  AttendanceModel? recordForDate(DateTime date) {
    final d0 = DateTime(date.year, date.month, date.day);
    for (final r in records) {
      final p = DateTime(r.punchIn.year, r.punchIn.month, r.punchIn.day);
      if (p == d0) return r;
    }
    return null;
  }
}

class AttendanceHistoryNotifier extends StateNotifier<AttendanceHistoryState> {
  final ApiClient _apiClient;

  AttendanceHistoryNotifier(this._apiClient) : super(const AttendanceHistoryState()) {
    fetch();
  }

  Future<void> fetch({int page = 1, int limit = 50}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.attendanceHistory,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final data = response.data;
      final raw = (data is Map<String, dynamic>) ? data['data'] : null;
      if (raw is! List) {
        state = state.copyWith(isLoading: false, records: const []);
        return;
      }

      final records = raw
          .whereType<Map<String, dynamic>>()
          .map(AttendanceModel.fromJson)
          .toList();

      state = state.copyWith(isLoading: false, records: records);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load attendance history.',
      );
    }
  }
}

final attendanceHistoryProvider =
    StateNotifierProvider<AttendanceHistoryNotifier, AttendanceHistoryState>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return AttendanceHistoryNotifier(apiClient);
});
