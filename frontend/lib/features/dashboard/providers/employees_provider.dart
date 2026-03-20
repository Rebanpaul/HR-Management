import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../../auth/providers/auth_provider.dart';

class EmployeesState {
  final List<EmployeeModel> employees;
  final bool isLoading;
  final String? error;

  const EmployeesState({
    this.employees = const [],
    this.isLoading = false,
    this.error,
  });

  EmployeesState copyWith({
    List<EmployeeModel>? employees,
    bool? isLoading,
    String? error,
  }) {
    return EmployeesState(
      employees: employees ?? this.employees,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class EmployeesNotifier extends StateNotifier<EmployeesState> {
  final ApiClient _apiClient;

  EmployeesNotifier(this._apiClient) : super(const EmployeesState()) {
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _apiClient.dio.get(ApiEndpoints.employees);
      final list = (res.data as List)
          .cast<Map<String, dynamic>>()
          .map(EmployeeModel.fromJson)
          .toList();
      state = state.copyWith(employees: list, isLoading: false);
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load employees.',
      );
    }
  }
}

final employeesProvider = StateNotifierProvider<EmployeesNotifier, EmployeesState>(
  (ref) => EmployeesNotifier(ref.watch(apiClientProvider)),
);
