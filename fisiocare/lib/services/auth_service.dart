import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _api.post(
      '/auth/login',
      {'username': username, 'password': password},
      withAuth: false,
    );

    if (response['success'] == true) {
      final token = response['data']['token'];
      final userData = response['data']['user'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConfig.tokenKey, token);
      await prefs.setString(AppConfig.userKey, jsonEncode(userData));
      await prefs.setString(AppConfig.roleKey, userData['role']['name']);
    }

    return response;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    return await _api.post('/auth/register', data, withAuth: false);
  }

  Future<Map<String, dynamic>> logout() async {
    final response = await _api.post('/auth/logout', {});
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.tokenKey);
    await prefs.remove(AppConfig.userKey);
    await prefs.remove(AppConfig.roleKey);
    return response;
  }

  Future<Map<String, dynamic>> getProfile() async {
    return await _api.get('/auth/profile');
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    return await _api.put('/auth/profile', data);
  }

  Future<Map<String, dynamic>> changePassword(
    String currentPassword,
    String newPassword,
    String confirmPassword,
  ) async {
    return await _api.post('/auth/change-password', {
      'current_password': currentPassword,
      'new_password': newPassword,
      'new_password_confirmation': confirmPassword,
    });
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    return await _api.post(
      '/auth/forgot-password',
      {'email': email},
      withAuth: false,
    );
  }

  Future<User?> getStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppConfig.userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<String?> getStoredRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConfig.roleKey);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConfig.tokenKey) != null;
  }
}
