import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sonara/core/home_screen.dart';
import 'package:sonara/core/models/user_model.dart';
import 'package:sonara/features/auth/credentials_screen.dart';
import 'package:sonara/features/auth/genre_selection_screen.dart';
import 'package:sonara/features/auth/role_selection_screen.dart';
import 'package:sonara/features/auth/sign_up_screen.dart';
import 'package:sonara/features/profile/dashboard_screen.dart';
import 'package:sonara/features/profile/profile_screen.dart';
import 'package:sonara/features/profile/services/create_service_screen.dart';
import 'package:sonara/features/profile/user_provider.dart';
import '../../features/auth/auth_notifier.dart';
import '../../features/auth/login_screen.dart';

/// Reine Redirect-Entscheidung — ohne GoRouter/Riverpod, damit testbar.
String? resolveRedirect({
  required AuthStatus authStatus,
  required AsyncValue<UserModel?> userAsync,
  required String location,
}) {
  debugPrint(
    'resolveRedirect: authStatus=$authStatus, userAsync=$userAsync, location=$location',
  );
  final isUnknown = authStatus == AuthStatus.unknown;
  final isAuthenticated = authStatus == AuthStatus.authenticated;
  final isOnboardingRoute =
      location.startsWith('/signup') || location == '/signin';

  if (isUnknown) return null;

  if (!isAuthenticated) {
    return isOnboardingRoute ? null : '/signup';
  }

  if (userAsync.isLoading) return null;

  final role = userAsync.value?.role;

  if (role == null) return null;

  final String home;
  switch (role) {
    case 'provider':
      home = '/dashboard';
    case 'artist':
      home = '/home';
    default:
      return null;
  }

  if (isOnboardingRoute) return home;

  if (role == 'artist' && location == '/dashboard') return '/home';
  if (role == 'provider' && location == '/home') return '/dashboard';

  return null;
}

// ← FIX: Bridge zwischen Riverpod und GoRouter. Ruft notifyListeners()
// bei Auth-/User-Aenderungen, sodass GoRouter seinen Redirect neu
// auswertet OHNE sich selbst (und initialLocation) neu zu erstellen.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
    ref.listen(userProvider, (_, __) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref); // ← FIX: statt ref.watch

  return GoRouter(
    initialLocation: '/signup',
    refreshListenable: notifier, // ← FIX: GoRouter reagiert hierueber
    redirect: (context, state) => resolveRedirect(
      authStatus: ref
          .read(authProvider)
          .status, // ← FIX: ref.read statt ref.watch
      userAsync: ref.read(userProvider), // ← FIX: ref.read statt ref.watch
      location: state.matchedLocation,
    ),
    routes: [
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup/credentials/:role',
        builder: (context, state) {
          final role = state.pathParameters['role'] ?? 'artist';
          return CredentialsScreen(role: role);
        },
      ),
      GoRoute(
        path: '/signup/roles/:role',
        builder: (context, state) {
          final role = state.pathParameters['role'] ?? 'artist';
          final credentials =
              (state.extra as Map<String, dynamic>?) ??
              {}; // ← FIX: war Map<String, String>
          return RolesSelectionScreen(role: role, credentials: credentials);
        },
      ),
      GoRoute(
        path: '/signup/genres/:role',
        builder: (context, state) {
          final role = state.pathParameters['role'] ?? 'artist';
          final credentials = (state.extra as Map<String, dynamic>?) ?? {};
          return GenreSelectionScreen(role: role, credentials: credentials);
        },
      ),
      ShellRoute(
        builder: (context, state, child) => HomeScreen(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Discovery — kommt gleich')),
            ),
          ),
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/bookings',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Bookings — kommt gleich')),
            ),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Chat — kommt gleich')),
            ),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/services/create',
            builder: (context, state) {
              return const CreateServiceScreen();
            },
          ),
        ],
      ),
    ],
  );
});
