import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/core/exceptions/app_exception.dart';
import 'package:sonara/core/models/user_model.dart';
import 'package:sonara/core/repositories/user_repository.dart';
import '../auth/auth_notifier.dart';

class UserProvider extends AsyncNotifier<UserModel?> {
  late UserRepository _repository;

  @override
  Future<UserModel?> build() async {
    _repository = ref.read(userRepositoryProvider);

    final authState = ref.watch(authProvider);

    switch (authState.status) {
      case AuthStatus.unknown:
        return Completer<UserModel?>().future;
      case AuthStatus.unauthenticated:
        return null;
      case AuthStatus.authenticated:
        // Repository wirft AppException; AsyncNotifier faengt sie
        // automatisch und setzt AsyncError.
        return _repository.fetchMe();
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.fetchMe());
  }

  Future<void> updateUser(Map<String, dynamic> updates) async {
    await _repository.updateUser(updates);
    await refresh();
  }

  Future<void> updateGenres(List<String> genres) async {
    await _repository.updateUser({'genres': genres});
    await refresh();
  }

  Future<void> updateSocialMedia(Map<String, String> socialMedia) async {
    await _repository.updateUser({'socialMedia': socialMedia});
    await refresh();
  }

  Future<void> uploadProfileImage(String filePath) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return;

    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('${firebaseUser.uid}.jpg');

    try {
      await ref.putFile(File(filePath));
      final url = await ref.getDownloadURL();

      try {
        await _repository.updateUser({'profileImageUrl': url});
        await refresh();
      } on AppException {
        // Backend-Update fehlgeschlagen -> hochgeladenes Bild wieder loeschen.
        await ref.delete();
        rethrow;
      }
    } on FirebaseException catch (e) {
      throw AppException(
        type: AppErrorType.unknown,
        message: e.message ?? 'Fehler beim Hochladen des Bildes.',
      );
    }
  }

  Future<void> addMusicTrack(String spotifyUrl, String? appleMusicUrl) async {
    await _repository.addMusicTrack(spotifyUrl, appleMusicUrl);
    await refresh();
  }

  Future<void> removeMusicTrack(String trackId) async {
    final current = state.value;
    if (current == null) return;

    final updatedTracks = current.musicTracks
        .where((t) => t.id != trackId)
        .map(
          (t) => {
            'id': t.id,
            'name': t.name,
            'artists': t.artists,
            'albumImage': t.albumImage,
            'spotifyUrl': t.spotifyUrl,
            'appleMusicUrl': t.appleMusicUrl,
          },
        )
        .toList();

    await _repository.removeMusicTrack(updatedTracks);
    await refresh();
  }
}

final userProvider = AsyncNotifierProvider<UserProvider, UserModel?>(
  UserProvider.new,
);
