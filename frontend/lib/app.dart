import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/ess/screens/ess_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final devBypassLogin = kDebugMode &&
      const bool.fromEnvironment('DEV_BYPASS_LOGIN', defaultValue: false);

  return GoRouter(
    initialLocation: devBypassLogin ? '/portal' : '/login',
    redirect: (context, state) {
      if (devBypassLogin) {
        if (state.matchedLocation == '/login') return '/portal';
        if (state.matchedLocation == '/dashboard') return '/portal';
        return null;
      }

      // Read directly instead of watch to avoid rebuilding router
      final authState = ref.read(authProvider);
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
    // Adding essentially a listener to re-evaluate redirect when auth changes
    refreshListenable: _AuthProviderListenable(ref),
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
        builder: (context, state) => const EssShell(),
      ),
    ],
  );
});

// Helper to make Riverpod Provider listenable for GoRouter
class _AuthProviderListenable extends ChangeNotifier {
  _AuthProviderListenable(ProviderRef ref) {
    ref.listen(authProvider, (previous, next) {
      notifyListeners();
    });
  }
}

class HrmsWebApp extends ConsumerWidget {
  const HrmsWebApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

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
