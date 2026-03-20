import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../../auth/providers/auth_provider.dart';

class PayslipsAdminState {
  final List<PayslipModel> payslips;
  final bool isLoading;
  final String? error;

  PayslipsAdminState({
    this.payslips = const [],
    this.isLoading = false,
    this.error,
  });

  PayslipsAdminState copyWith({
    List<PayslipModel>? payslips,
    bool? isLoading,
    String? error,
  }) {
    return PayslipsAdminState(
      payslips: payslips ?? this.payslips,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class PayslipsAdminNotifier extends StateNotifier<PayslipsAdminState> {
  final ApiClient _apiClient;

  PayslipsAdminNotifier(this._apiClient) : super(PayslipsAdminState()) {
    fetchPayslips();
  }

  Future<void> fetchPayslips() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _apiClient.dio.get(ApiEndpoints.payslips);
      final list = (res.data as List)
          .cast<Map<String, dynamic>>()
          .map(PayslipModel.fromJson)
          .toList();
      state = state.copyWith(payslips: list, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Failed to load payslips.');
    }
  }

  Future<void> createPayslip({
    required String employeeId,
    required int month,
    required int year,
    required double basicSalary,
    required double deductions,
    String? pdfUrl,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final netSalary = basicSalary - deductions;
      await _apiClient.dio.post(
        ApiEndpoints.payslips,
        data: {
          'employeeId': employeeId,
          'month': month,
          'year': year,
          'basicSalary': basicSalary,
          'deductions': deductions,
          'netSalary': netSalary,
          'pdfUrl': pdfUrl,
        },
      );
      await fetchPayslips();
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create payslip.',
      );
    }
  }
}

final payslipsAdminProvider =
    StateNotifierProvider<PayslipsAdminNotifier, PayslipsAdminState>(
  (ref) => PayslipsAdminNotifier(ref.watch(apiClientProvider)),
);
