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
    print('UserProvider build() called');
    final firebaseUser = await FirebaseAuth.instance.authStateChanges().first;
    print('Firebase user: ${firebaseUser?.uid}');
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
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode} — ${e.response?.data}');
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
}

final userProvider = AsyncNotifierProvider<UserProvider, UserModel?>(
  UserProvider.new,
);
