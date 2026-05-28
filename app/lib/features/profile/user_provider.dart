import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      print('Response: ${response.data}');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode} — ${e.response?.data}');
      return null;
    }
  }

  Future<void> updateUser(Map<String, dynamic> updates) async {
    try {
      final response = await apiClient.patch('/auth/me', data: updates);
      state = AsyncData(
        UserModel.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      print('DioException: ${e.response?.statusCode} — ${e.response?.data}');
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
}

final userProvider = AsyncNotifierProvider<UserProvider, UserModel?>(
  UserProvider.new,
);
