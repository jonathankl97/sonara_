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
}

final userProvider = AsyncNotifierProvider<UserProvider, UserModel?>(
  UserProvider.new,
);
