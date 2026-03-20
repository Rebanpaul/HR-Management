import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/portal/screens/portal_shell.dart';
import 'features/portal/screens/profile_screen.dart';

class HrmsWebApp extends ConsumerWidget {
  const HrmsWebApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Default behavior for now: skip login during local UI testing.
    // Disable anytime with: --dart-define=DEV_BYPASS_LOGIN=false
    final devBypassLogin = kDebugMode &&
        const bool.fromEnvironment('DEV_BYPASS_LOGIN', defaultValue: false);
    final authState = ref.watch(authProvider);

    final router = GoRouter(
      initialLocation: devBypassLogin ? '/portal' : '/login',
      redirect: (context, state) {
        if (devBypassLogin) {
          if (state.matchedLocation == '/login') return '/portal';
          if (state.matchedLocation == '/dashboard') return '/portal';
          return null;
        }

        final isLoggedIn = authState.isAuthenticated;
        final isOnLogin = state.matchedLocation == '/login';

        final role = authState.user?.role;
        final isAdmin = role == 'HR_ADMIN' || role == 'SUPER_ADMIN';
        final isOnPortal = state.matchedLocation.startsWith('/portal');
        final isOnDashboard = state.matchedLocation == '/dashboard';

        if (!isLoggedIn && !isOnLogin) return '/login';

        if (isLoggedIn && isOnLogin) {
          return isAdmin ? '/dashboard' : '/portal';
        }

        if (isLoggedIn && !isAdmin && isOnDashboard) return '/portal';
        if (isLoggedIn && isAdmin && isOnPortal) return '/dashboard';

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/portal',
          builder: (context, state) => const PortalShell(),
          routes: [
            GoRoute(
              path: 'profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: 'HRMS Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
