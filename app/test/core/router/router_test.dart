import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonara/core/models/user_model.dart';
import 'package:sonara/core/router/router.dart';

import 'package:sonara/features/auth/auth_notifier.dart';

void main() {
  final fixedDate = DateTime.utc(2024, 1, 15, 10);

  UserModel userWithRole(String role) => UserModel(
        id: 'user-1',
        email: 'test@sonara.de',
        role: role,
        createdAt: fixedDate,
      );

  final artist = userWithRole('artist');
  final provider = userWithRole('provider');
  final admin = userWithRole('admin');

  group('resolveRedirect — Auth-Status', () {
    test('unknown -> null (wartet, entscheidet nicht)', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.unknown,
        userAsync: const AsyncLoading<UserModel?>(),
        location: '/home',
      );

      expect(result, isNull);
    });

    test('unauthenticated auf geschützter Route -> /signup', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.unauthenticated,
        userAsync: const AsyncData<UserModel?>(null),
        location: '/home',
      );

      expect(result, '/signup');
    });

    test('unauthenticated auf Onboarding-Route -> null (darf bleiben)', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.unauthenticated,
        userAsync: const AsyncData<UserModel?>(null),
        location: '/signup',
      );

      expect(result, isNull);
    });

    test('unauthenticated auf /signin -> null (darf bleiben)', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.unauthenticated,
        userAsync: const AsyncData<UserModel?>(null),
        location: '/signin',
      );

      expect(result, isNull);
    });
  });

  group('resolveRedirect — Profil-Ladezustand', () {
    test('authenticated, Profil lädt noch -> null (nicht voreilig routen)', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.authenticated,
        userAsync: const AsyncLoading<UserModel?>(),
        location: '/signup',
      );

      expect(result, isNull);
    });

    test('authenticated, Profil-Fehler -> null (HomeScreen zeigt Error)', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.authenticated,
        userAsync: AsyncError<UserModel?>('boom', StackTrace.empty),
        location: '/home',
      );

      expect(result, isNull);
    });

    test('authenticated, Profil null -> null (stehenlassen)', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.authenticated,
        userAsync: const AsyncData<UserModel?>(null),
        location: '/home',
      );

      expect(result, isNull);
    });
  });

  group('resolveRedirect — rollenbasierte Startseite nach Onboarding', () {
    test('Artist nach Onboarding -> /home', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.authenticated,
        userAsync: AsyncData<UserModel?>(artist),
        location: '/signup',
      );

      expect(result, '/home');
    });

    test('Provider nach Onboarding -> /dashboard', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.authenticated,
        userAsync: AsyncData<UserModel?>(provider),
        location: '/signup',
      );

      expect(result, '/dashboard');
    });

    test('Artist auf /signin -> /home', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.authenticated,
        userAsync: AsyncData<UserModel?>(artist),
        location: '/signin',
      );

      expect(result, '/home');
    });
  });

  group('resolveRedirect — Rollen-Guards', () {
    test('Artist auf /dashboard -> /home', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.authenticated,
        userAsync: AsyncData<UserModel?>(artist),
        location: '/dashboard',
      );

      expect(result, '/home');
    });

    test('Provider auf /home -> /dashboard', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.authenticated,
        userAsync: AsyncData<UserModel?>(provider),
        location: '/home',
      );

      expect(result, '/dashboard');
    });
  });

  group('resolveRedirect — erlaubte Routen ohne Redirect', () {
    test('Artist auf /home -> null (korrekt, bleibt)', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.authenticated,
        userAsync: AsyncData<UserModel?>(artist),
        location: '/home',
      );

      expect(result, isNull);
    });

    test('Provider auf /dashboard -> null (korrekt, bleibt)', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.authenticated,
        userAsync: AsyncData<UserModel?>(provider),
        location: '/dashboard',
      );

      expect(result, isNull);
    });

    test('Artist auf geteilter Route /bookings -> null', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.authenticated,
        userAsync: AsyncData<UserModel?>(artist),
        location: '/bookings',
      );

      expect(result, isNull);
    });

    test('Provider auf geteilter Route /chat -> null', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.authenticated,
        userAsync: AsyncData<UserModel?>(provider),
        location: '/chat',
      );

      expect(result, isNull);
    });
  });

  group('resolveRedirect — admin (vorerst kein Routing)', () {
    test('Admin nach Onboarding -> null (bewusst nicht geroutet)', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.authenticated,
        userAsync: AsyncData<UserModel?>(admin),
        location: '/signup',
      );

      expect(result, isNull);
    });

    test('Admin auf /home -> null (kein Guard, kein Redirect)', () {
      final result = resolveRedirect(
        authStatus: AuthStatus.authenticated,
        userAsync: AsyncData<UserModel?>(admin),
        location: '/home',
      );

      expect(result, isNull);
    });
  });
}