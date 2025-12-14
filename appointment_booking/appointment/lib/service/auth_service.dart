// lib/services/auth_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';
import '../config/env.dart';

class AuthService {
  static Future<LoginResponseModel> login({
    required String mobile,
    required String password,
  }) async {
    final uri = Uri.parse('${Env.apiBaseUrl}/auth/login');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'mobile': mobile,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
      jsonDecode(response.body) as Map<String, dynamic>;
      return LoginResponseModel.fromJson(data);
    } else {
      try {
        final Map<String, dynamic> errorData =
        jsonDecode(response.body) as Map<String, dynamic>;
        final message = errorData['message']?.toString() ?? 'Login failed';
        throw Exception(message);
      } catch (_) {
        throw Exception('Login failed (${response.statusCode})');
      }
    }
  }

  // NEW: register user
  static Future<RegisterResponseModel> register({
    required String name,
    required String mobile,
    required String password,
    String? email,
  }) async {
    final uri = Uri.parse('${Env.apiBaseUrl}/auth/register');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'mobile': mobile,
        'password': password,
        'email': email,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> data =
      jsonDecode(response.body) as Map<String, dynamic>;
      return RegisterResponseModel.fromJson(data);
    } else {
      try {
        final Map<String, dynamic> errorData =
        jsonDecode(response.body) as Map<String, dynamic>;
        final message = errorData['message']?.toString() ?? 'Register failed';
        throw Exception(message);
      } catch (_) {
        throw Exception('Register failed (${response.statusCode})');
      }
    }
  }
}
