import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonara/core/models/user_model.dart';
import 'package:sonara/core/network/api_client.dart';

class UserProvider extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    final firebaseUser = await FirebaseAuth.instance.authStateChanges().first;

    if (firebaseUser == null) return null;
    return _fetchUserData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await _fetchUserData());
  }

  Future<UserModel?> _fetchUserData() async {
    try {
      final response = await apiClient.get('/auth/me');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (_) {
      return null;
    }
  }

  Future<void> updateUser(Map<String, dynamic> updates) async {
    try {
      await apiClient.patch('/users/me', data: updates);
      await refresh();
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<void> updateGenres(List<String> genres) async {
    try {
      await apiClient.patch('/users/me', data: {'genres': genres});
      await refresh();
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<void> updateSocialMedia(Map<String, String> socialMedia) async {
    try {
      await apiClient.patch('/users/me', data: {'socialMedia': socialMedia});
      await refresh();
    } on DioException catch (_) {
      rethrow;
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
        await apiClient.patch('/users/me', data: {'profileImageUrl': url});
        await refresh();
      } catch (e) {
        await ref.delete();
        rethrow;
      }
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<void> addMusicTrack(String spotifyUrl, String? appleMusicUrl) async {
    try {
      await apiClient.post(
        '/spotify/tracks',
        data: {'spotifyUrl': spotifyUrl, 'appleMusicUrl': appleMusicUrl},
      );
      await refresh();
    } on DioException catch (_) {
      rethrow;
    }
  }

  Future<void> removeMusicTrack(String trackId) async {
    try {
      final current = state.value;
      if (current == null) return;

      final updatedTracks = current.musicTracks
          .where((t) => t.id != trackId)
          .toList();

      await apiClient.patch(
        '/users/me',
        data: {
          'musicTracks': updatedTracks
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
              .toList(),
        },
      );
      await refresh();
    } on DioException catch (_) {
      rethrow;
    }
  }
}

final userProvider = AsyncNotifierProvider<UserProvider, UserModel?>(
  UserProvider.new,
);
