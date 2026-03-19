import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/portal/screens/portal_shell.dart';
import 'features/profile/screens/profile_screen.dart';

class HrmsApp extends ConsumerWidget {
  const HrmsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(authProvider);

    // Default behavior for now: skip login during local UI testing.
    // Disable anytime with: --dart-define=DEV_BYPASS_LOGIN=false
    final devBypassLogin = kDebugMode &&
        const bool.fromEnvironment('DEV_BYPASS_LOGIN', defaultValue: true);

    final router = GoRouter(
      initialLocation: devBypassLogin ? '/portal' : '/login',
      redirect: (context, state) {
        if (devBypassLogin) {
          if (state.matchedLocation == '/login') return '/portal';
          return null;
        }

        final isLoggedIn = ref.read(authProvider).isAuthenticated;
        final isOnLogin = state.matchedLocation == '/login';

        if (!isLoggedIn && !isOnLogin) return '/login';
        if (isLoggedIn && isOnLogin) return '/portal';
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
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
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'HRMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
