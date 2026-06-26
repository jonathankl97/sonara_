import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sonara/core/home_screen.dart';
import 'package:sonara/core/models/user_model.dart';
import 'package:sonara/features/auth/credentials_screen.dart';
import 'package:sonara/features/auth/genre_selection_screen.dart';
import 'package:sonara/features/auth/role_selection_screen.dart';
import 'package:sonara/features/auth/sign_up_screen.dart';
import 'package:sonara/features/profile/profile_screen.dart';
import 'package:sonara/features/profile/user_provider.dart';
import '../../features/auth/auth_notifier.dart';
import '../../features/auth/login_screen.dart';

/// Reine Redirect-Entscheidung — ohne GoRouter/Riverpod, damit testbar.
String? resolveRedirect({
  required AuthStatus authStatus,
  required AsyncValue<UserModel?> userAsync,
  required String location,
}) {
  final isUnknown = authStatus == AuthStatus.unknown;
  final isAuthenticated = authStatus == AuthStatus.authenticated;
  final isOnboardingRoute =
      location.startsWith('/signup') || location == '/signin';

  // Firebase-Auth-Status noch nicht geladen -> abwarten
  if (isUnknown) return null;

  // Nicht eingeloggt -> raus aus geschützten Routes
  if (!isAuthenticated) {
    return isOnboardingRoute ? null : '/signup';
  }

  // Eingeloggt, aber App-Profil lädt noch -> nicht voreilig wegrouten
  if (userAsync.isLoading) return null;

  final role = userAsync.value?.role;

  // Profil-Fehler oder (noch) kein Profil -> stehenlassen
  if (role == null) return null;

  // Rollenbasierte Startseite. admin & unbekannte Rollen: bewusst
  // kein Routing -> stehenlassen, statt blind auf Artist-Seite zu raten.
  final String home;
  switch (role) {
    case 'provider':
      home = '/dashboard';
    case 'artist':
      home = '/home';
    default:
      return null;
  }

  // Onboarding abgeschlossen -> rollenbasierte Startseite
  if (isOnboardingRoute) return home;

  // Rollen-Guard: falsche Startseite korrigieren
  if (role == 'artist' && location == '/dashboard') return '/home';
  if (role == 'provider' && location == '/home') return '/dashboard';

  return null;
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final userAsync = ref.watch(userProvider);

  return GoRouter(
    initialLocation: '/signup',
    redirect: (context, state) => resolveRedirect(
      authStatus: authState.status,
      userAsync: userAsync,
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
          final credentials = (state.extra as Map<String, String>?) ?? {};
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
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Dashboard — kommt gleich')),
            ),
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
        ],
      ),
    ],
  );
});