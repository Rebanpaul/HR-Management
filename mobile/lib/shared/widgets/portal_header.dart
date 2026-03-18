import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_provider.dart';

class PortalHeader extends ConsumerWidget {
  final VoidCallback? onProfileTap;

  const PortalHeader({
    super.key,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(authProvider).user;

    final initials = (user?.employee?.firstName.isNotEmpty ?? false)
        ? user!.employee!.firstName.substring(0, 1).toUpperCase()
        : 'U';

    return Row(
      children: [
        InkWell(
          onTap: onProfileTap,
          borderRadius: BorderRadius.circular(24),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: colorScheme.primaryContainer,
                child: Text(
                  initials,
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.employee?.fullName ?? 'Employee',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    _roleLabel(user?.role),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications coming soon.')),
            );
          },
        ),
      ],
    );
  }

  static String _roleLabel(String? role) {
    switch (role) {
      case 'HR_ADMIN':
        return 'Human Resource Manager';
      case 'MANAGER':
        return 'Manager';
      case 'SUPER_ADMIN':
        return 'Administrator';
      case 'EMPLOYEE':
      default:
        return 'Employee';
    }
  }
}
