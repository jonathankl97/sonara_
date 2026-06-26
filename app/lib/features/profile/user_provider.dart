import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
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

    // An den AuthState koppeln statt direkt an Firebase:
    // build() läuft bei jedem Statuswechsel neu.
    final authState = ref.watch(authProvider);

    switch (authState.status) {
      case AuthStatus.unknown:
        // Nie abschließen -> Provider bleibt in AsyncLoading,
        // bis authState auf authenticated/unauthenticated wechselt
        // und build() erneut läuft.
        return Completer<UserModel?>().future;
      case AuthStatus.unauthenticated:
        return null;
      case AuthStatus.authenticated:
        return _fetchUserData();
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _fetchUserData());
  }

  Future<UserModel?> _fetchUserData() async {
    try {
      return await _repository.fetchMe();
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<void> updateUser(Map<String, dynamic> updates) async {
    try {
      await _repository.updateUser(updates);
      await refresh();
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<void> updateGenres(List<String> genres) async {
    try {
      await _repository.updateUser({'genres': genres});
      await refresh();
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<void> updateSocialMedia(Map<String, String> socialMedia) async {
    try {
      await _repository.updateUser({'socialMedia': socialMedia});
      await refresh();
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<void> uploadProfileImage(String filePath) async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) return;

      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${firebaseUser.uid}.jpg');

      await ref.putFile(File(filePath));
      final url = await ref.getDownloadURL();

      try {
        await _repository.updateUser({'profileImageUrl': url});
        await refresh();
      } on DioException catch (e) {
        await ref.delete();
        throw AppException.fromDioException(e);
      }
    } on FirebaseException catch (e) {
      throw AppException(
        type: AppErrorType.unknown,
        message: e.message ?? 'Fehler beim Hochladen des Bildes.',
      );
    }
  }

  Future<void> addMusicTrack(String spotifyUrl, String? appleMusicUrl) async {
    try {
      await _repository.addMusicTrack(spotifyUrl, appleMusicUrl);
      await refresh();
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<void> removeMusicTrack(String trackId) async {
    try {
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
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }
}

final userProvider = AsyncNotifierProvider<UserProvider, UserModel?>(
  UserProvider.new,
);
