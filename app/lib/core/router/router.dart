import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sonara/features/auth/credentials_screen.dart';
import 'package:sonara/features/auth/genre_selection_screen.dart';
import 'package:sonara/features/auth/role_selection_screen.dart';
import 'package:sonara/features/auth/sign_up_screen.dart';
import '../../features/auth/auth_notifier.dart';
import '../../features/auth/login_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/signup',
    redirect: (context, state) {
      final isAuthenticated = authState.status == AuthStatus.authenticated;
      final isUnknown = authState.status == AuthStatus.unknown;
      final isOnboardingRoute =
          state.matchedLocation.startsWith('/signup') ||
          state.matchedLocation == '/signin';

      if (isUnknown) return null;
      if (!isAuthenticated && !isOnboardingRoute) return '/signup';
      if (isAuthenticated && isOnboardingRoute) return '/home';
      return null;
    },
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
      GoRoute(
        path: '/home',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Home'))),
      ),
    ],
  );
});
