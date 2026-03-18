import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';

/// A widget that only renders its child if the user has one of the allowed roles.
class RoleBasedWidget extends ConsumerWidget {
  final List<String> allowedRoles;
  final Widget child;
  final Widget? fallback;

  const RoleBasedWidget({
    super.key,
    required this.allowedRoles,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final userRole = authState.user?.role;

    if (userRole != null && allowedRoles.contains(userRole)) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}
