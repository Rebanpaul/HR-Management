import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../../auth/providers/auth_provider.dart';

class EmployeeMeState {
  final EmployeeModel? employee;
  final bool isLoading;
  final String? error;

  const EmployeeMeState({
    this.employee,
    this.isLoading = false,
    this.error,
  });

  EmployeeMeState copyWith({
    EmployeeModel? employee,
    bool? isLoading,
    String? error,
    bool clearEmployee = false,
  }) {
    return EmployeeMeState(
      employee: clearEmployee ? null : (employee ?? this.employee),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class EmployeeMeNotifier extends StateNotifier<EmployeeMeState> {
  final ApiClient _apiClient;

  EmployeeMeNotifier(this._apiClient) : super(const EmployeeMeState()) {
    fetch();
  }

  Future<void> fetch() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.employeeMe);
      if (response.data is Map<String, dynamic>) {
        state = state.copyWith(
          isLoading: false,
          employee: EmployeeModel.fromJson(response.data as Map<String, dynamic>),
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load profile.',
      );
    }
  }
}

final employeeMeProvider =
    StateNotifierProvider<EmployeeMeNotifier, EmployeeMeState>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return EmployeeMeNotifier(apiClient);
});
