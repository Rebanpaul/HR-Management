import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import '../../auth/providers/auth_provider.dart';

class TeamLeavesState {
  final List<LeaveRequestModel> leaves;
  final bool isLoading;
  final String? error;

  const TeamLeavesState({
    this.leaves = const [],
    this.isLoading = false,
    this.error,
  });

  TeamLeavesState copyWith({
    List<LeaveRequestModel>? leaves,
    bool? isLoading,
    String? error,
  }) {
    return TeamLeavesState(
      leaves: leaves ?? this.leaves,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TeamLeavesNotifier extends StateNotifier<TeamLeavesState> {
  final ApiClient _apiClient;

  TeamLeavesNotifier(this._apiClient) : super(const TeamLeavesState()) {
    fetchTeamLeaves();
  }

  Future<void> fetchTeamLeaves() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await _apiClient.dio.get(ApiEndpoints.teamLeaves);
      final list = (res.data as List)
          .cast<Map<String, dynamic>>()
          .map(LeaveRequestModel.fromJson)
          .toList();
      state = state.copyWith(leaves: list, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Failed to load leaves.');
    }
  }

  Future<void> approve(String id) async {
    try {
      await _apiClient.dio.patch(ApiEndpoints.approveLeave(id));
      await fetchTeamLeaves();
    } catch (_) {
      state = state.copyWith(error: 'Failed to approve leave.');
    }
  }

  Future<void> reject(String id) async {
    try {
      await _apiClient.dio.patch(ApiEndpoints.rejectLeave(id));
      await fetchTeamLeaves();
    } catch (_) {
      state = state.copyWith(error: 'Failed to reject leave.');
    }
  }
}

final teamLeavesProvider =
    StateNotifierProvider<TeamLeavesNotifier, TeamLeavesState>(
  (ref) => TeamLeavesNotifier(ref.watch(apiClientProvider)),
);
