// lib/core/network/interceptors/auth_interceptor.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Injects JWT token into every authenticated request
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final requiresAuth = options.extra['requiresAuth'] as bool? ?? true;

    if (requiresAuth) {
      final token = await _storage.read(key: 'jwt_token');

      if (token != null && token.isNotEmpty && token != 'null') {
        options.headers['Authorization'] = 'Bearer $token';
        debugPrint('🔑 Auth token attached to: ${options.path}');
      } else {
        debugPrint('⚠️ No auth token found for: ${options.path}');
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      debugPrint('🔄 401 received, clearing token');
      await _storage.delete(key: 'jwt_token');
    }
    handler.next(err);
  }
}