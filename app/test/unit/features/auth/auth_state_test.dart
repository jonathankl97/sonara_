import 'package:flutter_test/flutter_test.dart';
import 'package:sonara/features/auth/auth_notifier.dart';

void main() {
  group('AuthState Konstruktoren', () {
    test('unknown setzt status auf unknown, kein User, kein Fehler', () {
      const state = AuthState.unknown();

      expect(state.status, AuthStatus.unknown);
      expect(state.user, isNull);
      expect(state.error, isNull);
    });

    test('unauthenticated setzt status auf unauthenticated', () {
      const state = AuthState.unauthenticated();

      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
      expect(state.error, isNull);
    });

    test('error setzt status auf unauthenticated und füllt error', () {
      const state = AuthState.error('Login fehlgeschlagen');

      expect(state.status, AuthStatus.unauthenticated);
      expect(state.error, 'Login fehlgeschlagen');
      expect(state.user, isNull);
    });
  });
}
