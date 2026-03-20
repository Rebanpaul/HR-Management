import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../../auth/providers/auth_provider.dart';

class PayslipsState {
  final List<PayslipModel> payslips;
  final bool isLoading;
  final String? error;

  const PayslipsState({
    this.payslips = const [],
    this.isLoading = false,
    this.error,
  });

  PayslipsState copyWith({
    List<PayslipModel>? payslips,
    bool? isLoading,
    String? error,
  }) {
    return PayslipsState(
      payslips: payslips ?? this.payslips,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  PayslipModel? get latest => payslips.isEmpty ? null : payslips.first;
}

class PayslipsNotifier extends StateNotifier<PayslipsState> {
  final ApiClient _apiClient;

  PayslipsNotifier(this._apiClient, {bool autoFetchMyPayslips = true})
      : super(const PayslipsState()) {
    if (autoFetchMyPayslips) {
      fetchMyPayslips();
    }
  }

  Future<void> fetchMyPayslips() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _apiClient.dio.get(ApiEndpoints.myPayslips);

      final raw = response.data;
      if (raw is! List) {
        state = state.copyWith(isLoading: false, payslips: const []);
        return;
      }

      final payslips = raw
          .whereType<Map<String, dynamic>>()
          .map(PayslipModel.fromJson)
          .toList();

      // Backend returns ordered desc already, but keep it safe.
      payslips.sort((a, b) {
        final y = b.year.compareTo(a.year);
        if (y != 0) return y;
        return b.month.compareTo(a.month);
      });

      state = state.copyWith(isLoading: false, payslips: payslips);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load payslips.',
      );
    }
  }
}

final payslipsProvider = StateNotifierProvider<PayslipsNotifier, PayslipsState>(
  (ref) {
    final apiClient = ref.read(apiClientProvider);
    return PayslipsNotifier(apiClient);
  },
);
