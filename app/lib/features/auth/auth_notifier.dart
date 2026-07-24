import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;

  const AuthState({required this.status, this.user, this.error});

  const AuthState.unknown() : this(status: AuthStatus.unknown);
  const AuthState.authenticated(User user)
    : this(status: AuthStatus.authenticated, user: user);
  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);
  const AuthState.error(String error)
    : this(status: AuthStatus.unauthenticated, error: error);
}

class AuthNotifier extends Notifier<AuthState> {
  StreamSubscription<User?>? _sub; // ← FIX: Subscription speichern

  @override
  AuthState build() {
    _sub?.cancel(); // ← FIX: Alten Listener canceln
    _sub = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    });

    ref.onDispose(() => _sub?.cancel()); // ← FIX: Beim Dispose aufraeumen

    return const AuthState.unknown();
  }

  Future<void> signInWithEmail(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
