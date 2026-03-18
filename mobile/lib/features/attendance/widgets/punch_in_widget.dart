import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/attendance_provider.dart';
import '../services/geolocation_service.dart';

class PunchInWidget extends ConsumerWidget {
  const PunchInWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceState = ref.watch(attendanceProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final isPunchedIn = attendanceState.isPunchedIn;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isPunchedIn
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isPunchedIn
                        ? Icons.access_time_filled_rounded
                        : Icons.access_time_rounded,
                    color: isPunchedIn
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attendance',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        isPunchedIn ? 'You are clocked in' : 'Not clocked in',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status chip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPunchedIn
                        ? Colors.green.withValues(alpha: 26)
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isPunchedIn ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: isPunchedIn ? Colors.green[700] : colorScheme.onSurfaceVariant,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            // Worked duration
            if (attendanceState.todayAttendance != null) ...[
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      attendanceState.todayAttendance!.workedHoursFormatted,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hours worked today',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Success / Error messages
            if (attendanceState.successMessage != null)
              _buildMessage(context, attendanceState.successMessage!,
                  Colors.green, Icons.check_circle_outline),
            if (attendanceState.error != null)
              _buildMessage(context, attendanceState.error!,
                  colorScheme.error, Icons.error_outline),

            // Punch button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: attendanceState.isLoading
                    ? null
                    : () => _handlePunch(ref, isPunchedIn),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isPunchedIn ? colorScheme.error : colorScheme.primary,
                  foregroundColor:
                      isPunchedIn ? colorScheme.onError : colorScheme.onPrimary,
                ),
                icon: attendanceState.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: isPunchedIn
                              ? colorScheme.onError
                              : colorScheme.onPrimary,
                        ),
                      )
                    : Icon(isPunchedIn
                        ? Icons.logout_rounded
                        : Icons.login_rounded),
                label: Text(isPunchedIn ? 'Punch Out' : 'Punch In'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(
      BuildContext context, String message, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(message, style: TextStyle(color: color, fontSize: 13)),
        ],
      ),
    );
  }

  Future<void> _handlePunch(WidgetRef ref, bool isPunchedIn) async {
    // Try to get location for geo-fencing
    final position = await GeolocationService.getCurrentPosition();

    if (isPunchedIn) {
      await ref.read(attendanceProvider.notifier).punchOut(
            latitude: position?.latitude,
            longitude: position?.longitude,
          );
    } else {
      await ref.read(attendanceProvider.notifier).punchIn(
            latitude: position?.latitude,
            longitude: position?.longitude,
          );
    }
  }
}
